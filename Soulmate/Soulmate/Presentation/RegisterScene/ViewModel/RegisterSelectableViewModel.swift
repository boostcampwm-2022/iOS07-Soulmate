//
//  RegisterGenderUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import Combine

class RegisterSelectableViewModel {
    
    var bag = Set<AnyCancellable>()
    
    var actions: RegisterViewModelActions?
    
    var registerUserInfo: RegisterUserInfo
    
    @Published var type: SelectableType.Type?
    @Published var selectedIndex: Int?
    
    struct Input {
        var didSelectedAtIndex: AnyPublisher<Int?, Never>
        var didTappedNextButton: AnyPublisher<Void, Never>
    }

    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
        var didChangedSelectableType: AnyPublisher<SelectableType.Type?, Never>
    }
    
    init(registerUserInfo: RegisterUserInfo) {
        self.registerUserInfo = registerUserInfo
    }
    
    func setType(type: SelectableType.Type) {
        self.type = type
    }

    func setActions(actions: RegisterViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didSelectedAtIndex
            .assign(to: \.selectedIndex, on: self)
            .store(in: &bag)
        
        input.didTappedNextButton
            .sink { [weak self] in
                self?.toNext()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = $selectedIndex
            .map { value in
                return value != nil
            }
            .eraseToAnyPublisher()
            
        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            didChangedSelectableType: $type.eraseToAnyPublisher()
        )
    }
    
    func toNext() {
        guard let type = type,
              let selectedIndex = selectedIndex else { return }
        
        switch type {
        case is GenderType.Type:
            registerUserInfo.gender = GenderType.allCases[selectedIndex]
        case is SmokingType.Type:
            registerUserInfo.smokingType = SmokingType.allCases[selectedIndex]
        case is DrinkingType.Type:
            registerUserInfo.drinkingType = DrinkingType.allCases[selectedIndex]
        default:
            return
        }

        actions?.nextStep?(registerUserInfo)
    }
    
    
}
