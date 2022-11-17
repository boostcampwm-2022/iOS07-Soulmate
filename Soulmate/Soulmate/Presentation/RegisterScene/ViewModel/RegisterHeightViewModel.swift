//
//  RegisterHeightViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import Combine

class RegisterHeightViewModel {
    var bag = Set<AnyCancellable>()
    
    var actions: RegisterViewModelActions?
    
    var registerUserInfo: RegisterUserInfo
    
    @Published var height = String()
    
    struct Input {
        var didChangedHeightValue: AnyPublisher<String, Never>
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
        input.didChangedHeightValue
            .assign(to: \.height, on: self)
            .store(in: &bag)
        
        input.didTappedNextButton
            .sink { [weak self] in
                self?.toNext()
            }
            .store(in: &bag)
        
        return Output()
    }
    
    func toNext() {
        
        guard let intHeight = Int(height) else { return }
        
        registerUserInfo.height = intHeight
        
        actions?.nextStep?(registerUserInfo)
    }
}
