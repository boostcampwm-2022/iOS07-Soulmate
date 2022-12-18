//
//  LoginViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import AuthenticationServices
import Combine
import FirebaseAuth
import SnapKit
import UIKit

final class LoginView: UIView {
    private lazy var titleLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "logo")?.withShadow(
            blur: 4,
            offset: CGSize(width: 0, height: 2),
            color: .black
        )
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var welcomeGreetingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        
        var paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.25
        paragraphStyle.alignment = .center
        
        label.attributedText = NSMutableAttributedString(
            string: "소울메이트에 오신것을 환영합니다!\n아래 버튼을 눌러 시작해주세요.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.addSubview(label)
        return label
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitle("Apple로 시작하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.setImage(UIImage(named: "logoApple"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 150)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        self.addSubview(button)
        return button
    }()
    
    lazy var phoneLoginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.borderPurple?.cgColor ?? UIColor.black.cgColor
        button.setTitle("전화번호로 시작하기", for: .normal)
        button.setTitleColor(UIColor.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.setImage(UIImage(named: "Phone"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 135)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        
        self.addSubview(button)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure

private extension LoginView {
    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {

        titleLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(117)
        }
        
        emojiImageView.snp.makeConstraints {
            $0.center.equalTo(self.safeAreaLayoutGuide.snp.center)
        }
        
        phoneLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(phoneLoginButton.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
        
        welcomeGreetingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-24)
        }
    }
}




final class LoginViewController: UIViewController {
    private var viewModel: LoginViewModel?
    private var loginView: LoginView?
    private var cancellables = Set<AnyCancellable>()
    private var currentNonce: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: LoginViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        let view = LoginView(frame: self.view.frame)
        self.loginView = view
        self.view = view
    }
}

// MARK: - View Generators

private extension LoginViewController {
    
    func bind() {
        guard let loginView = loginView else { return }
        let output = viewModel?.transform(
            input: LoginViewModel.Input(
                didTappedAppleLoginButton: loginView.appleLoginButton.tapPublisher(),
                didTappedPhoneLoginButton: loginView.phoneLoginButton.tapPublisher()
            )
        )
        
        output?.didReadyForAppleLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] request in
                self?.showAppleLogin(request: request)
            }
            .store(in: &cancellables)
        
        output?.didChangedCurrentNonce
            .sink { [weak self] value in
                self?.currentNonce = value
            }
            .store(in: &cancellables)
    }
    
}

private extension LoginViewController {
    
    func showAppleLogin(request: ASAuthorizationRequest) {
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            viewModel?.tryAppleLogin(idToken: idTokenString, nonce: nonce)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
