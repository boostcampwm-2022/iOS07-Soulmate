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

class LoginViewModel: ViewModelable {
    
    typealias Action = LoginViewModelActions
    
    var downLoadDetailInfoUseCase: DownLoadDetailInfoUseCase
    var registerStateValidateUseCase: RegisterStateValidateUseCase
    
    struct Input {
        var didTappedPhoneLoginButton: AnyPublisher<Void, Never>
    }
    struct Output {}
        
    var bag = Set<AnyCancellable>()
    
    var actions: Action?
    
    init(
        downLoadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        registerStateValidateUseCase: RegisterStateValidateUseCase
    ) {
        self.registerStateValidateUseCase = registerStateValidateUseCase
        self.downLoadDetailInfoUseCase = downLoadDetailInfoUseCase
    }
    
    func setActions(actions: Action) {
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
