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
    var doneSignIn: ((RegisterState) -> Void)?
}

class CertificationViewModel {
    
    var bag = Set<AnyCancellable>()
    
    var authUseCase: AuthUseCase
    var registerStateValidateUseCase: RegisterStateValidateUseCase
    var loadDetailInfoUseCase: LoadDetailInfoUseCase
    
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
    
    init(
        authUseCase: AuthUseCase,
        registerStateValidateUseCase: RegisterStateValidateUseCase,
        loadDetailInfoUseCase: LoadDetailInfoUseCase
    ) {
        self.authUseCase = authUseCase
        self.registerStateValidateUseCase = registerStateValidateUseCase
        self.loadDetailInfoUseCase = loadDetailInfoUseCase
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
                let registerUserInfo = try await loadDetailInfoUseCase.loadDetailInfo(userUid: Auth.auth().currentUser!.uid)
                let state = registerStateValidateUseCase.validateRegisterState(registerUserInfo: registerUserInfo)
                await MainActor.run { actions?.doneSignIn?(state) }
            } catch DecodingError.valueNotFound {
                await MainActor.run { actions?.doneSignIn?(.none) }
            } catch {
                print(error)
            }
        }
    }
}
