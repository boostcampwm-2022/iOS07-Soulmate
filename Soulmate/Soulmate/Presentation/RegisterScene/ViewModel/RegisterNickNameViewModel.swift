//
//  RegisterNickNameViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import Combine

class RegisterNickNameViewModel {
    var bag = Set<AnyCancellable>()
    
    var actions: RegisterViewModelActions?
    
    var registerUserInfo: RegisterUserInfo
    
    @Published var nickName: String?
    
    struct Input {
        var didChangedNicknameValue: AnyPublisher<String?, Never>
        var didTappedNextButton: AnyPublisher<Void, Never>
    }

    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    init(registerUserInfo: RegisterUserInfo) {
        self.registerUserInfo = registerUserInfo
    }

    func setActions(actions: RegisterViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didChangedNicknameValue
            .assign(to: \.nickName, on: self)
            .store(in: &bag)
        
        input.didTappedNextButton
            .sink { [weak self] in
                self?.toNext()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = $nickName
            .map { value in
                guard let value = value,
                      !value.isEmpty else { return false }
                return true
            }
            .eraseToAnyPublisher()
            
        return Output(
            isNextButtonEnabled: isNextButtonEnabled
        )
    }
    
    func toNext() {
        guard let nickName = nickName else { return }
        
        registerUserInfo.nickName = nickName
        
        actions?.nextStep?(registerUserInfo)
    }
}
