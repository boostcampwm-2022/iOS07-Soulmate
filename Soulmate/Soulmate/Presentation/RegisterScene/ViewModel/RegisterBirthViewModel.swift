//
//  RegisterBirthViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import Combine

class RegisterBirthViewModel {
    var bag = Set<AnyCancellable>()
    
    var actions: RegisterViewModelActions?
    
    var registerUserInfo: RegisterUserInfo
    
    @Published var birthDate: Date = Date()
    
    struct Input {
        var didChangedBirthDate: AnyPublisher<Date, Never>
        var didTappedNextButton: AnyPublisher<Void, Never>
    }

    struct Output {}
    
    init(registerUserInfo: RegisterUserInfo) {
        self.registerUserInfo = registerUserInfo
    }

    func setActions(actions: RegisterViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didChangedBirthDate
            .assign(to: \.birthDate, on: self)
            .store(in: &bag)
        
        input.didTappedNextButton
            .sink { [weak self] in
                self?.toNext()
            }
            .store(in: &bag)
        
        return Output()
    }
    
    func toNext() {
        registerUserInfo.birthDay = birthDate
        actions?.nextStep?(registerUserInfo)
    }
}
