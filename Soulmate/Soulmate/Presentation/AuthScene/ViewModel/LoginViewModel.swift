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
    var showRegisterFlow: ((RegisterUserInfo?) -> Void)?
    var showMainTabFlow: (() -> Void)?
    var showPhoneLoginFlow: (() -> Void)?
}

class LoginViewModel {
    
    var downLoadDetailInfoUseCase: DownLoadDetailInfoUseCase
    var registerStateValidateUseCase: RegisterStateValidateUseCase
    
    struct Input {
        var didTappedPhoneLoginButton: AnyPublisher<Void, Never>
    }
    struct Output {}
        
    var bag = Set<AnyCancellable>()
    
    var actions: LoginViewModelActions?
    
    init(
        downLoadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        registerStateValidateUseCase: RegisterStateValidateUseCase
    ) {
        self.registerStateValidateUseCase = registerStateValidateUseCase
        self.downLoadDetailInfoUseCase = downLoadDetailInfoUseCase
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
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let registerUserInfo = try await downLoadDetailInfoUseCase.downloadDetailInfo(userUid: uid)
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
