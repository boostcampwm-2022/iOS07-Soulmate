//
//  PhoneNumberViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import Combine

struct PhoneNumberViewModelActions {
    var showCertificationPage: ((String) -> Void)?
}

class PhoneNumberViewModel {
    var bag = Set<AnyCancellable>()
    
    var actions: PhoneNumberViewModelActions?
    
    @Published var phoneNumber: String?
    
    struct Input {
        var didChangedPhoneNumber: AnyPublisher<String?, Never>
        var didTouchedNextButton: AnyPublisher<Void, Never>
    }
    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    func setActions(actions: PhoneNumberViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didChangedPhoneNumber
            .assign(to: \.phoneNumber, on: self)
            .store(in: &bag)
        
        input.didTouchedNextButton
            .sink { [weak self] _ in
                self?.nextButtonTouched()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = $phoneNumber
            .compactMap { $0 }
            .map { value in
                print(value)
                return value.count == 11
            }
            .eraseToAnyPublisher()
        
        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
    
    func nextButtonTouched() {
        guard let phoneNumber = phoneNumber else { return }
        
        // TODO: verify phone number
        
        actions?.showCertificationPage?(phoneNumber)
    }
}
