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
    var showRegisterFlow: ((RegisterUserInfo?) -> Void)?
    var showMainTabFlow: (() -> Void)?
}

class CertificationViewModel: ViewModelable {
    
    // MARK: Interface defined AssociatedType

    typealias Action = CertificationViewModelActions
    
    struct Input {
        var didCertificationNumberChanged: AnyPublisher<String, Never>
        var didTouchedNextButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var nextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    // MARK: UseCase
    
    var phoneSignInUseCase: PhoneSignInUseCase
    var registerStateValidateUseCase: RegisterStateValidateUseCase
    var downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    
    // MARK: Properties
    
    var actions: CertificationViewModelActions?
    var bag = Set<AnyCancellable>()
    
    var phoneNumber: String?
    
    @Published var certificationNumber: String = ""
    
    // MARK: Configuration
    
    init(
        phoneSignInUseCase: PhoneSignInUseCase,
        registerStateValidateUseCase: RegisterStateValidateUseCase,
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    ) {
        self.phoneSignInUseCase = phoneSignInUseCase
        self.registerStateValidateUseCase = registerStateValidateUseCase
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    // MARK: Data Bind
    
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
    
    // MARK: Data Bind
    
    func nextButtonTouched() {
        Task { [weak self] in
            do {
                guard let self else { return }
                try await phoneSignInUseCase.certifyWithSMSCode(certificationCode: self.certificationNumber)
                let registerUserInfo = try await downloadDetailInfoUseCase.downloadMyDetailInfo()
                let state = registerStateValidateUseCase.validateRegisterState(registerUserInfo: registerUserInfo)

                switch state {
                case .part:
                    await MainActor.run { actions?.showRegisterFlow?(registerUserInfo) }
                case .done:
                    await MainActor.run { actions?.showMainTabFlow?() }
                }
            } catch DecodingError.valueNotFound {
                await MainActor.run { actions?.showRegisterFlow?(nil) }
            } catch {
                print(error.localizedDescription)
            }
        }

    }
}
