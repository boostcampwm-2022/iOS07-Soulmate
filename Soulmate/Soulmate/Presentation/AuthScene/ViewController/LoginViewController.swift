//
//  LoginViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import AuthenticationServices
import Combine
import CryptoKit
import FirebaseAuth
import SnapKit
import UIKit

final class LoginViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    private var viewModel: LoginViewModel?
    private var currentNonce: String?
    
    private lazy var titleLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "logo")?.withShadow(
            blur: 4,
            offset: CGSize(width: 0, height: 2),
            color: .black
        )
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
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
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var appleLoginButton: UIButton = {
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
        
        button.addAction(UIAction { [weak self] _ in
            self?.startSignInWithAppleFlow()
        }, for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    private lazy var phoneLoginButton: UIButton = {
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
        
        self.view.addSubview(button)
        return button
    }()
    
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
        configureView()
        configureLayout()
    }
}

// MARK: - View Generators

private extension LoginViewController {
    
    func bind() {
        let _ = viewModel?.transform(
            input: LoginViewModel.Input(
                didTappedAppleLoginButton: appleLoginButton.tapPublisher(),
                didTappedPhoneLoginButton: phoneLoginButton.tapPublisher()
            )
        )
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {

        titleLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(117)
        }
        
        emojiImageView.snp.makeConstraints {
            $0.center.equalTo(self.view.safeAreaLayoutGuide.snp.center)
        }
        
        phoneLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
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

private extension LoginViewController {
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashString
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
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
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
