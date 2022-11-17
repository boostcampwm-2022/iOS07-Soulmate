//
//  NicknameSettingViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit
import Combine

final class NicknameSettingViewController: UIViewController {
        
    var viewFrame: CGRect?
    var bag = Set<AnyCancellable>()
    
    var viewModel: RegisterNickNameViewModel?
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "소울메이트에서 사용하실\n닉네임을 적어주세요.",
            descriptionText: "프로필에서 표시되는 이름으로, 언제든지 변경할 수 있어요!"
        )
        view.addSubview(headerView)
        return headerView
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.placeholder = "두글자 이상 입력해주세요."
        
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = GradientButton(title: "다음")
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: RegisterNickNameViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstants()
        configureView()
        configureLayout()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        nicknameTextField.addUnderLine()
    }
}

extension NicknameSettingViewController: ProgressAnimatable {
    func preset() {
        nextButton.isHidden = true
        view.backgroundColor = .clear
    }
    
    func setInitStateAsTo() {
        guard let viewFrame else { return }
        
        view.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: viewFrame.midY)
    }
    
    func setFinalStateAsTo() {
        guard let viewFrame else { return }
        
        view.center = CGPoint(
            x: viewFrame.midX,
            y: viewFrame.midY)
    }
    
    func setInitStateAsFrom() {
        
    }
    
    func setFinalStateAsFrom() {
        
    }
    
    func reset() {        
        nextButton.isHidden = false
        view.backgroundColor = .white
    }
}

private extension NicknameSettingViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: RegisterNickNameViewModel.Input(
                didChangedNicknameValue: nicknameTextField.textPublisher(),
                didTappedNextButton: nextButton.tapPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .sink { [weak self] value in
                self?.nextButton.isEnabled = value
            }
            .store(in: &bag)
        
    }
    
    func setConstants() {
        viewFrame = view.frame
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {

        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(self.registerHeaderStackView.snp.bottom).offset(70)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
    }
}

#if DEBUG
import SwiftUI
struct NicknameSettingViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        NicknameSettingViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                NicknameSettingViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
