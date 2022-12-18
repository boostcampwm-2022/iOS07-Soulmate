//
//  LoginViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/10.
//

import Foundation
import Combine
import FirebaseAuth
import AuthenticationServices

struct LoginViewModelActions {
    var showRegisterFlow: ((UserDetailInfo?) -> Void)?
    var showMainTabFlow: (() -> Void)?
    var showPhoneLoginFlow: (() -> Void)?
}

class LoginViewModel: ViewModelable {
    
    // MARK: Interface defined AssociatedType
    
    typealias Action = LoginViewModelActions
    
    struct Input {
        var didTappedAppleLoginButton: AnyPublisher<Void, Never>
        var didTappedPhoneLoginButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var didReadyForAppleLogin: AnyPublisher<ASAuthorizationRequest, Never>
        var didChangedCurrentNonce: AnyPublisher<String?, Never>
    }
    
    // MARK: UseCase
    
    var downLoadDetailInfoUseCase: DownLoadDetailInfoUseCase
    var registerStateValidateUseCase: RegisterStateValidateUseCase
    var generateRandomNonceUseCase: GenerateRandomNonceUseCase
    var convertToSha256UseCase: ConvertToSha256UseCase
    var appleSignInUseCase: AppleSignInUseCase
    
    // MARK: Properties
    
    var actions: Action?
    var bag = Set<AnyCancellable>()
    @Published var currentNonce: String?
    
    var didReadyForAppleLogin = PassthroughSubject<ASAuthorizationRequest, Never>()
    
    // MARK: Configuration
    
    init(
        downLoadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        registerStateValidateUseCase: RegisterStateValidateUseCase,
        generateRandomNonceUseCase: GenerateRandomNonceUseCase,
        convertToSha256UseCase: ConvertToSha256UseCase,
        appleSignInUseCase: AppleSignInUseCase
    ) {
        self.registerStateValidateUseCase = registerStateValidateUseCase
        self.downLoadDetailInfoUseCase = downLoadDetailInfoUseCase
        self.generateRandomNonceUseCase = generateRandomNonceUseCase
        self.convertToSha256UseCase = convertToSha256UseCase
        self.appleSignInUseCase = appleSignInUseCase
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    // MARK: Data Bind
    
    func transform(input: Input) -> Output {
        input.didTappedAppleLoginButton
            .sink { [weak self] in
                self?.setAppleLogin()
            }
            .store(in: &bag)
        
        input.didTappedPhoneLoginButton
            .sink { [weak self] in
                self?.phoneLoginTapped()
            }
            .store(in: &bag)
        
        return Output(
            didReadyForAppleLogin: didReadyForAppleLogin.eraseToAnyPublisher(),
            didChangedCurrentNonce: $currentNonce.eraseToAnyPublisher()
        )
    }
    
    // MARK: Logic
    @available(iOS 13, *)
    func setAppleLogin() {
        let nonce = generateRandomNonceUseCase.execute()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = convertToSha256UseCase.execute(nonce)
        
        didReadyForAppleLogin.send(request)
    }
    
    func tryAppleLogin(idToken: String, nonce: String) {
        Task {
            do {
                try await appleSignInUseCase.execute(idToken: idToken, nonce: nonce)
                doneAppleLogin()
            }
            catch {
                print(error)
            }
        }
    }
    
    func doneAppleLogin() {
        Task {
            do {
                let registerUserInfo = try await downLoadDetailInfoUseCase.downloadMyDetailInfo()
                let state = registerStateValidateUseCase.validateRegisterState(registerUserInfo: registerUserInfo)
                switch state {
                case .part:
                    await MainActor.run { actions?.showRegisterFlow?(registerUserInfo) }
                case .done:
                    await MainActor.run { actions?.showMainTabFlow?() }
                }
            } catch DecodingError.valueNotFound {
                await MainActor.run { actions?.showRegisterFlow?(nil) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func phoneLoginTapped() {
        actions?.showPhoneLoginFlow?()
    }
    
}
