//
//  ReigsterViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/18.
//

import UIKit
import SnapKit
import Combine

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
        RegisterIntroductionView()
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
        button.setImage(UIImage(named: "chevron.left"), for: .normal)
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
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            viewModel?.quit()
        }
    }

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

private extension RegisterViewController {
    func bind() {
        guard let viewModel = viewModel,
              let genderView = childView[0] as? RegisterSelectableView,
              let nickNameView = childView[1] as? RegisterNickNameView,
              let birthView = childView[2] as? RegisterBirthView,
              let heightView = childView[3] as? RegisterHeightView,
              let mbtiView = childView[4] as? RegisterMbtiView,
              let smokingView = childView[5] as? RegisterSelectableView,
              let drinkingView = childView[6] as? RegisterSelectableView,
              let introductionView = childView[7] as? RegisterIntroductionView else { return }
                
        let didFinishedRegister = PassthroughSubject<Void, Never>()
        
        nextButton.tapPublisher()
            .sink { [weak self] _ in
                if self?.currentPage == 7 {
                    self?.viewModel?.register()
                } else {
                    self?.nextPage()
                }
            }
            .store(in: &bag)
        
        prevButton.tapPublisher()
            .sink { [weak self] _ in
                self?.prevPage()
            }
            .store(in: &bag)
        
        $currentPage
            .sink { value in
                if value != 0 {
                    self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: self.prevButton), animated: true)
                }
                else {
                    self.navigationItem.setLeftBarButton(nil, animated: true)
                }
                let backButton = self.navigationItem.leftBarButtonItem
            }
            .store(in: &bag)
        
        let output = viewModel.transform(
            input: RegisterViewModel.Input(
                didChangedPageIndex: $currentPage.eraseToAnyPublisher(),
                didChangedGenderIndex: genderView.$selectedIndex.eraseToAnyPublisher(),
                didChangedNickNameValue: nickNameView.nicknameTextField.textPublisher(),
                didChangedHeightValue: heightView.$selectedHeight.eraseToAnyPublisher(),
                didChangedBirthValue: birthView.birthPicker.datePublisher(),
                didChangedMbtiValue: mbtiView.mbtiPublisher(),
                didChangedSmokingIndex: smokingView.$selectedIndex.eraseToAnyPublisher(),
                didChangedDrinkingIndex: drinkingView.$selectedIndex.eraseToAnyPublisher(),
                didChangedIntroductionValue: introductionView.introductionTextView.publisher(for: \.text).eraseToAnyPublisher(),
                didFinishedRegister: didFinishedRegister.eraseToAnyPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .sink { [weak self] value in
                self?.nextButton.isEnabled = value
            }
            .store(in: &bag)
        
        
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        childView.forEach {
            self.view.addSubview($0)
        }
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

        guard let _ = viewModel.genderIndex else { return 0 }
        guard let _ = viewModel.nickName else { return 1 }
        guard let _ = viewModel.smokingIndex else { return 4 }
        guard let _ = viewModel.drinkingIndex else { return 5}
        guard let _ = viewModel.introduction else { return 6 }
        return 7
    }
    
    // MARK: 페이지 레이아웃 초기 셋팅
    func configurePageLayout() {
    
        // MARK: 지금은 currentPage 초기값을 0으로 셋팅해놔서 사실 상 이 라인은 필요 없을듯
        for i in 0..<currentPage {
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
        
        for i in currentPage+1..<childView.count {
            childView[i].snp.remakeConstraints {
                $0.centerY.equalTo(self.view.snp.centerY)
                $0.leading.equalTo(self.view.snp.trailing)
                $0.width.height.equalToSuperview()
            }
        }
    }
}


#if DEBUG
import SwiftUI
struct RegisterViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        RegisterViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                RegisterViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
