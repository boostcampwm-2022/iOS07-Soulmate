//
//  LoginViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/10.
//

import Foundation
import Combine

struct LoginViewModelActions {
    var showAppleLoginSheet: (() -> Void)?
    var showPhoneLoginPage: (() -> Void)?
}

class LoginViewModel {
    struct Input {
        var didTappedAppleLoginButton: AnyPublisher<Void, Never>
        var didTappedPhoneLoginButton: AnyPublisher<Void, Never>
    }
    struct Output {}
        
    var bag = Set<AnyCancellable>()
    
    var actions: LoginViewModelActions?
    
    init() {}
    
    func setActions(actions: LoginViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didTappedAppleLoginButton
            .sink { [weak self] in
                self?.appleLogin()
            }
            .store(in: &bag)
        
        input.didTappedPhoneLoginButton
            .sink { [weak self] in
                self?.phoneLogin()
            }
            .store(in: &bag)
        
        return Output()
    }
    
    func appleLogin() {
        actions?.showAppleLoginSheet?()
    }
    
    func phoneLogin() {
        actions?.showPhoneLoginPage?()
    }
    
}
