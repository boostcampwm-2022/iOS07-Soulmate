//
//  LoginViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/10.
//

import Foundation
import Combine
import FirebaseAuth

struct LoginViewModelActions {
    var doneAppleLogin: ((RegisterState) -> Void)?
    var showPhoneLoginPage: (() -> Void)?
}

class LoginViewModel {
    
    var loadDetailInfoUseCase: LoadDetailInfoUseCase
    var registerStateValidateUseCase: RegisterStateValidateUseCase
    
    struct Input {
        var didTappedPhoneLoginButton: AnyPublisher<Void, Never>
    }
    struct Output {}
        
    var bag = Set<AnyCancellable>()
    
    var actions: LoginViewModelActions?
    
    init(
        loadDetailInfoUseCase: LoadDetailInfoUseCase,
        registerStateValidateUseCase: RegisterStateValidateUseCase
    ) {
        self.registerStateValidateUseCase = registerStateValidateUseCase
        self.loadDetailInfoUseCase = loadDetailInfoUseCase
    }
    
    func setActions(actions: LoginViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didTappedPhoneLoginButton
            .sink { [weak self] in
                self?.phoneLoginTapped()
            }
            .store(in: &bag)
        
        return Output()
    }
    
    func doneAppleLogin() {
        Task {
            do {
                let registerUserInfo = try await loadDetailInfoUseCase.loadDetailInfo(userUid: Auth.auth().currentUser!.uid)
                let state = registerStateValidateUseCase.validateRegisterState(registerUserInfo: registerUserInfo)
                await MainActor.run { actions?.doneAppleLogin?(state) }
            } catch DecodingError.valueNotFound {
                await MainActor.run { actions?.doneAppleLogin?(.none) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func phoneLoginTapped() {
        actions?.showPhoneLoginPage?()
    }
    
}
