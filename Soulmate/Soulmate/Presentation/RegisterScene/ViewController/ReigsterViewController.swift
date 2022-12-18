//
//  ReigsterViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/18.
//

import UIKit
import SnapKit
import Combine
import PhotosUI

final class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: RegisterViewModel?
    private var registerView: RegisterView?
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: RegisterViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        configureHistory()
        bind()
    }
    
    override func loadView() {
        super.loadView()
        let view = RegisterView(frame: self.view.frame)
        self.view = view
        self.registerView = view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 첫 페이지에서 pop 될 때 코디네이터 종료 및 로그아웃 용
        if self.isMovingFromParent && registerView?.currentPage == 0 {
            viewModel?.quit()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let nickNameView = registerView?.childView[1] as? RegisterNickNameView else { return }
        nickNameView.nicknameTextField.addUnderLine()
    }
    
}

// MARK: - Configure

private extension RegisterViewController {
    
    func configure() {
        registerView?.currentPage = targetPage()
        registerView?.configurePageLayout()
        guard let photoView = registerView?.childView[8] as? RegisterPhotoView else { return }
        photoView.delegate = self
    }
        
    // MARK: - 이전에 입력한 부분까지 이동
    
    func configureHistory() {
        guard let viewModel = viewModel,
              let registerView = registerView,
              let genderView = registerView.childView[0] as? RegisterSelectableView<GenderType>,
              let nickNameView = registerView.childView[1] as? RegisterNickNameView,
              let birthView = registerView.childView[2] as? RegisterBirthView,
              let heightView = registerView.childView[3] as? RegisterHeightView,
              let mbtiView = registerView.childView[4] as? RegisterMbtiView,
              let smokingView = registerView.childView[5] as? RegisterSelectableView<SmokingType>,
              let drinkingView = registerView.childView[6] as? RegisterSelectableView<DrinkingType>,
              let introductionView = registerView.childView[7] as? RegisterIntroductionView else { return }
        
        genderView.configureHistory(selectableValue: viewModel.genderType)
        nickNameView.configureHistory(nickName: viewModel.nickName)
        birthView.configureHistory(birth: viewModel.birth)
        heightView.configureHistory(height: viewModel.height)
        mbtiView.configureHistory(mbti: viewModel.mbti)
        smokingView.configureHistory(selectableValue: viewModel.smokingType)
        drinkingView.configureHistory(selectableValue: viewModel.drinkingType)
        introductionView.configureHistory(introduction: viewModel.introduction)
    }
    
    func bind() {
        guard let viewModel = viewModel,
              let registerView = registerView,
              let genderView = registerView.childView[0] as? RegisterSelectableView<GenderType>,
              let nickNameView = registerView.childView[1] as? RegisterNickNameView,
              let birthView = registerView.childView[2] as? RegisterBirthView,
              let heightView = registerView.childView[3] as? RegisterHeightView,
              let mbtiView = registerView.childView[4] as? RegisterMbtiView,
              let smokingView = registerView.childView[5] as? RegisterSelectableView<SmokingType>,
              let drinkingView = registerView.childView[6] as? RegisterSelectableView<DrinkingType>,
              let introductionView = registerView.childView[7] as? RegisterIntroductionView,
              let photoView = registerView.childView[8] as? RegisterPhotoView,
              let congratulationView = registerView.childView[9] as? RegisterCongraturationsView else { return }
                
        
        photoView.$imageList
            .compactMap { $0[0] }
            .sink { value in
                guard let image = UIImage(data: value) else { return }
                
                let ratio = image.size.width / 50
                let ratioHeight = image.size.height * ratio
                let newImage = UIImage.resizeImage(image: image, targetSize: CGSize(width: 50, height: ratioHeight))!
            
                guard let data = newImage.jpegData(compressionQuality: 1) else { return }
                viewModel.chatImageData = data
            }
            .store(in: &cancellables)
        
        
        registerView.nextButton.tapPublisher()
            .sink { [weak registerView] _ in
                registerView?.nextPage()
            }
            .store(in: &cancellables)
        
        registerView.prevButton.tapPublisher()
            .sink { [weak registerView] _ in
                registerView?.prevPage()
            }
            .store(in: &cancellables)
        
        registerView.$currentPage
            .sink { [weak self, weak registerView] value in
                switch value {
                case 0:
                    self?.navigationItem.setLeftBarButton(nil, animated: true)
                case 1...8:
                    self?.navigationItem.setLeftBarButton(UIBarButtonItem(customView: registerView?.prevButton ?? UIView()), animated: true)
                case 9: // last page
                    self?.navigationItem.setLeftBarButton(nil, animated: true)
                    self?.navigationItem.hidesBackButton = true
                    registerView?.nextButton.isHidden = true
                default:
                    return
                }
            }
            .store(in: &cancellables)
        
        let output = viewModel.transform(
            input: RegisterViewModel.Input(
                didChangedPageIndex: registerView.$currentPage.eraseToAnyPublisher(),
                didChangedGenderType: genderView.selectablePublisher(),
                didChangedNickNameValue: nickNameView.nickNamePublisher(),
                didChangedHeightValue: heightView.heightPublisher(),
                didChangedBirthValue: birthView.birthPublisher(),
                didChangedMbtiValue: mbtiView.mbtiPublisher(),
                didChangedSmokingType: smokingView.selectablePublisher(),
                didChangedDrinkingType: drinkingView.selectablePublisher(),
                didChangedIntroductionValue: introductionView.introductionPublisher(),
                didChangedImageListValue: photoView.imageListPublisher(),
                didTappedNextButton: registerView.nextButton.tapPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak registerView] value in
                registerView?.nextButton.isEnabled = value
            }
            .store(in: &cancellables)
        
        output.isProfilImageSetted
            .receive(on: DispatchQueue.main)
            .sink { value in
                guard let value = value else { return }
                congratulationView.profileImage.image = UIImage(data: value)
            }
            .store(in: &cancellables)
        
        output.isAllInfoUploaded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel?.actions?.finishRegister?()
            }
            .store(in: &cancellables)
    }
    
    // MARK: 처음 보여줄 페이지 선정
    func targetPage() -> Int {
        guard let viewModel = viewModel else { return 0 }

        guard let _ = viewModel.genderType else { return 0 }
        guard let _ = viewModel.nickName else { return 1 }
        guard let _ = viewModel.mbti else { return 4}
        guard let _ = viewModel.smokingType else { return 5 }
        guard let _ = viewModel.drinkingType else { return 6}
        guard let _ = viewModel.introduction else { return 7 }
        return 8
    }
}

// MARK: 포토뷰 델리게이트

extension RegisterViewController: RegisterPhotoViewDelegate {
    func presentPhotoPicker(_ registerPhotoView: RegisterPhotoView) {
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.selectionLimit = 1
        phPickerConfiguration.filter = .images
        phPickerConfiguration.preferredAssetRepresentationMode = .current

        let phPicker = PHPickerViewController(configuration: phPickerConfiguration)
        phPicker.delegate = self
        self.present(phPicker, animated: true)
    }
}

extension RegisterViewController: PHPickerViewControllerDelegate { //PHPicker 델리게이트
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak registerView] (data, error) in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            let ratio = image.size.width / 390
            let ratioHeight = image.size.height * ratio

            let newImage = UIImage.resizeImage(image: image, targetSize: CGSize(width: 390, height: ratioHeight))!
            
            guard let data = newImage.jpegData(compressionQuality: 0.9) else { return }
            
            guard let photoView = registerView?.childView[8] as? RegisterPhotoView,
                  let index = photoView.pickingItem else { return }
            
            photoView.imageList[index] = data
            photoView.pickingItem = nil
            
            DispatchQueue.main.async { [weak photoView] in
                photoView?.snapshotDataSoucre()
            }
        }
    }
}
