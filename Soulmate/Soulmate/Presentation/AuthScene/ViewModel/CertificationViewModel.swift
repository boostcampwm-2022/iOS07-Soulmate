//
//  CertificationViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import Combine
import FirebaseAuth

struct CertificationViewModelActions {
    var doneCertification: ((Bool) -> Void)?
}

class CertificationViewModel {
    
    var bag = Set<AnyCancellable>()
    
    var authUseCase: AuthUseCase
    
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
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
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
    
        Task { [weak self] in
            do {
                guard let self else { return }
                try await authUseCase.certifyWithSMSCode(certificationCode: self.certificationNumber)
                
                //여기서 한번더 디비를 확인해 개인정보설정을 모두 마친 사람이면 true, 아니면 false 전달해서 회원가입 코디네이터 실행
                await MainActor.run {
                    self.actions?.doneCertification?(true)
                }
            }
            catch {
                print(error)
            }
        }
        
    }
}
