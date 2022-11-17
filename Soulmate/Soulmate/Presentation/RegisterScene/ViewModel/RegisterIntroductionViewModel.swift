//
//  RegisterIntroductionViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import Combine

class RegisterIntroductionViewModel {
    var bag = Set<AnyCancellable>()
    
    var actions: RegisterViewModelActions?
    
    var registerUserInfo: RegisterUserInfo
    
    @Published var introduction: String?
    
    struct Input {
        var didChangedIntroductionValue: AnyPublisher<String?, Never>
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
        input.didChangedIntroductionValue
            .assign(to: \.introduction, on: self)
            .store(in: &bag)
        
        input.didTappedNextButton
            .sink { [weak self] in
                self?.toNext()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = $introduction
            .map { value in
                guard let value = value,
                      !value.isEmpty else { return false }
                return true
            }
            .eraseToAnyPublisher()
        
        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
    
    func toNext() {
        registerUserInfo.aboutMe = introduction
        actions?.nextStep?(registerUserInfo)
        print(registerUserInfo)
    }
}
