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

class RegisterViewController: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    var viewModel: RegisterViewModel?
    
    @Published var currentPage: Int = 0

    var childView = [
        RegisterSelectableView(selectableType: GenderType.self),
        RegisterNickNameView(),
        RegisterBirthView(),
        RegisterHeightView(),
        RegisterMbtiView(),
        RegisterSelectableView(selectableType: SmokingType.self),
        RegisterSelectableView(selectableType: DrinkingType.self),
        RegisterIntroductionView(),
        RegisterPhotoView(),
        RegisterCongraturationsView()
    ]
    
    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar(frame: .zero)
        self.view.addSubview(bar)
        return bar
    }()
    
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        self.view.addSubview(button)
        return button
    }()
    
    private lazy var prevButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        
        currentPage = targetPage()
        configurePageLayout()
        configureHistory()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            viewModel?.quit()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let nickNameView = childView[1] as? RegisterNickNameView else { return }
        nickNameView.nicknameTextField.addUnderLine()
    }
    
}

// MARK: 화면 전환 관련 기능

private extension RegisterViewController {
    
    func nextPage() {
        progressBar.goToNextStep()
        
        childView[currentPage].snp.remakeConstraints {
            $0.trailing.equalTo(self.view.snp.leading)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        childView[currentPage + 1].snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        animate()
        currentPage += 1
    }
    
    func prevPage() {
        progressBar.goToExStep()

        childView[currentPage].snp.remakeConstraints {
            $0.leading.equalTo(self.view.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        childView[currentPage - 1].snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }

        animate()
        currentPage -= 1
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2) {
          self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: 초기 셋팅

private extension RegisterViewController {
    
    // FIXME: 너무 지저분한데 이게 맞나? 뷰 안에 메서드를 만들어줘야하나??
    
    func configureHistory() { // 이전에 했던 부분까지 셋팅
        guard let viewModel = viewModel,
              let genderView = childView[0] as? RegisterSelectableView,
              let nickNameView = childView[1] as? RegisterNickNameView,
              let birthView = childView[2] as? RegisterBirthView,
              let heightView = childView[3] as? RegisterHeightView,
              let mbtiView = childView[4] as? RegisterMbtiView,
              let smokingView = childView[5] as? RegisterSelectableView,
              let drinkingView = childView[6] as? RegisterSelectableView,
              let introductionView = childView[7] as? RegisterIntroductionView else { return }
        
        if let gender = viewModel.genderType,
           let index = GenderType.allCases.firstIndex(of: gender) {
            genderView.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
            genderView.selectedIndex = index
        }
        
        if let nickName = viewModel.nickName {
            nickNameView.nicknameTextField.text = nickName
        }

        birthView.birthPicker.date = viewModel.birth
        heightView.selectedHeight = String(viewModel.height)
        
        if let mbti = viewModel.mbti,
           let innerIndex = InnerType.allCases.firstIndex(of: mbti.innerType),
           let recogIndex = RecognizeType.allCases.firstIndex(of: mbti.recognizeType),
           let judgeIndex = JudgementType.allCases.firstIndex(of: mbti.judgementType),
           let lifeIndex = LifeStyleType.allCases.firstIndex(of: mbti.lifeStyleType) {
            innerIndex == 0 ? mbtiView.innerTypeView.leftButtonTapped() : mbtiView.innerTypeView.rightButtonTapped()
            recogIndex == 0 ? mbtiView.recognizeTypeView.leftButtonTapped() : mbtiView.recognizeTypeView.rightButtonTapped()
            judgeIndex == 0 ? mbtiView.judgementTypeView.leftButtonTapped() : mbtiView.judgementTypeView.rightButtonTapped()
            lifeIndex == 0 ? mbtiView.lifeStyleTypeView.leftButtonTapped() : mbtiView.lifeStyleTypeView.rightButtonTapped()
        }
        
        if let smoking = viewModel.smokingType,
           let index = SmokingType.allCases.firstIndex(of: smoking) {
            smokingView.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
            smokingView.selectedIndex = index
        }
        
        if let drinking = viewModel.drinkingType,
           let index = DrinkingType.allCases.firstIndex(of: drinking) {
            drinkingView.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
            drinkingView.selectedIndex = index
        }
        
        if let introduction = viewModel.introduction {
            introductionView.introductionTextView.text = introduction
        }
    }
    
    func bind() {
        guard let viewModel = viewModel,
              let genderView = childView[0] as? RegisterSelectableView,
              let nickNameView = childView[1] as? RegisterNickNameView,
              let birthView = childView[2] as? RegisterBirthView,
              let heightView = childView[3] as? RegisterHeightView,
              let mbtiView = childView[4] as? RegisterMbtiView,
              let smokingView = childView[5] as? RegisterSelectableView,
              let drinkingView = childView[6] as? RegisterSelectableView,
              let introductionView = childView[7] as? RegisterIntroductionView,
              let photoView = childView[8] as? RegisterPhotoView,
              let congratulationView = childView[9] as? RegisterCongraturationsView else { return }
                
        nextButton.tapPublisher()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.currentPage < 9 {
                    self.nextPage()
                }
            }
            .store(in: &bag)
        
        prevButton.tapPublisher()
            .sink { [weak self] _ in
                self?.prevPage()
            }
            .store(in: &bag)
        
        $currentPage
            .sink { [weak self] value in
                switch value {
                case 0:
                    self?.navigationItem.setLeftBarButton(nil, animated: true)
                case 1...8:
                    self?.navigationItem.setLeftBarButton(UIBarButtonItem(customView: self?.prevButton ?? UIView()), animated: true)
                case 9:
                    self?.navigationItem.setLeftBarButton(nil, animated: true)
                    self?.navigationItem.hidesBackButton = true
                    self?.nextButton.isHidden = true
                default:
                    return
                }
            }
            .store(in: &bag)
        
        let output = viewModel.transform(
            input: RegisterViewModel.Input(
                didChangedPageIndex: $currentPage.eraseToAnyPublisher(),
                didChangedGenderType: genderView.selectablePublisher(type: GenderType.self),
                didChangedNickNameValue: nickNameView.nickNamePublisher(),
                didChangedHeightValue: heightView.heightPublisher(),
                didChangedBirthValue: birthView.birthPublisher(),
                didChangedMbtiValue: mbtiView.mbtiPublisher(),
                didChangedSmokingType: smokingView.selectablePublisher(type: SmokingType.self),
                didChangedDrinkingType: drinkingView.selectablePublisher(type: DrinkingType.self),
                didChangedIntroductionValue: introductionView.introductionPublisher(),
                didChangedImageListValue: photoView.imageListPublisher(),
                didTappedNextButton: nextButton.tapPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    self?.nextButton.isEnabled = value
                }
            }
            .store(in: &bag)
        
        output.isProfilImageSetted
            .sink { value in
                guard let value = value else { return }
                DispatchQueue.main.async {
                    congratulationView.profileImage.image = UIImage(data: value)
                }
            }
            .store(in: &bag)
        
        output.isAllInfoUploaded
            .sink { [weak self] in
                DispatchQueue.main.async {
                    self?.viewModel?.actions?.finishRegister?()
                }
            }
            .store(in: &bag)
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        childView.forEach {
            self.view.addSubview($0)
        }
        
        guard let photoView = childView[8] as? RegisterPhotoView else { return }
        photoView.delegate = self
    }
    
    func configureLayout() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(54)
        }
    }

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
    
    // MARK: 페이지 레이아웃 초기 셋팅
    func configurePageLayout() {
    
        for i in 0..<currentPage {
            progressBar.goToNextStep()
            childView[i].snp.remakeConstraints {
                $0.trailing.equalTo(self.view.snp.leading)
                $0.centerY.equalTo(self.view.snp.centerY)
                $0.width.height.equalToSuperview()
            }
        }
        
        childView[currentPage].snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        for i in currentPage + 1..<childView.count {
            childView[i].snp.remakeConstraints {
                $0.centerY.equalTo(self.view.snp.centerY)
                $0.leading.equalTo(self.view.snp.trailing)
                $0.width.height.equalToSuperview()
            }
        }
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

        results.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak self] (data, error) in
            guard let data = data else { return }
            guard let photoView = self?.childView[8] as? RegisterPhotoView,
                  let index = photoView.pickingItem else { return }
            
            photoView.imageList[index] = data
            photoView.pickingItem = nil
            
            DispatchQueue.main.async {
                photoView.collectionView.reloadData()
            }
        }
    }
    
    
}
