//
//  PhoneNumberViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import Combine
import FirebaseAuth

struct PhoneNumberViewModelActions {
    var showCertificationPage: ((String) -> Void)?
}

class PhoneNumberViewModel {
    var bag = Set<AnyCancellable>()
    
    var authUseCase: AuthUseCase
    
    var actions: PhoneNumberViewModelActions?
    
    @Published var phoneNumber: String?
    
    struct Input {
        var didChangedPhoneNumber: AnyPublisher<String?, Never>
        var didTouchedNextButton: AnyPublisher<Void, Never>
    }
    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
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
                return value.count == 11
            }
            .eraseToAnyPublisher()
        
        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
    
    func nextButtonTouched() {
        guard var phoneNumber = phoneNumber else { return }
        
        // 국가코드 부분은 추후 수정
        phoneNumber.removeFirst()
        phoneNumber = "+82" + phoneNumber
        
        Task { [phoneNumber, weak self] in
            do {
                let verificationID = try await authUseCase.verifyPhoneNumber(phoneNumber: phoneNumber)
                await MainActor.run { [self] in
                    self?.actions?.showCertificationPage?(phoneNumber)
                }
            }
            catch {
                print(error)
            }
        }
        
    }
}
