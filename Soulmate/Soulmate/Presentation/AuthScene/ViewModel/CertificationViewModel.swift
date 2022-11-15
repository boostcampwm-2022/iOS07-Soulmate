//
//  CertificationViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import Combine

struct CertificationViewModelActions {
    var doneCertification: ((Bool) -> Void)?
}

class CertificationViewModel {
    
    var bag = Set<AnyCancellable>()
    
    var actions: CertificationViewModelActions?
    
    var phoneNumber: String?
    @Published var certificationNumber: String = ""
    
    struct Input {
        var didCertificationNumberChanged: AnyPublisher<String, Never>
        var didTouchedNextButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var nextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    func setActions(actions: CertificationViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {

        input.didCertificationNumberChanged
            .assign(to: \.certificationNumber, on: self)
            .store(in: &bag)
        
        input.didTouchedNextButton
            .sink { [weak self] _ in
                self?.nextButtonTouched()
            }
            .store(in: &bag)
        
        let nextButtonEnabled = $certificationNumber
            .compactMap { $0 }
            .map { value in
                return value.count == 6
            }
            .eraseToAnyPublisher()
        
        return Output(nextButtonEnabled: nextButtonEnabled)
    }
    
    func nextButtonTouched() {
        
        // TODO: signIn 수행해야함
        
        actions?.doneCertification?(true)
    }
}
