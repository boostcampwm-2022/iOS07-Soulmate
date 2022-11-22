//
//  AuthCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import FirebaseAuth

class AuthCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .auth
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginPage()
    }
    
    lazy var showLoginPage: () -> Void = { [weak self] in
        let loadDetailInfoUseCase = DefaultLoadDetailInfoUseCase()
        let registerDetailInfoUseCase = DefaultRegisterStateValidateUseCase()
        
        let viewModel = LoginViewModel(
            loadDetailInfoUseCase: loadDetailInfoUseCase,
            registerStateValidateUseCase: registerDetailInfoUseCase
        )
        viewModel.setActions(
            actions: LoginViewModelActions(
                doneAppleLogin: self?.doneSignIn,
                showPhoneLoginPage: self?.showPhoneLoginPage
            )
        )
        
        let vc = LoginViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showPhoneLoginPage: () -> Void = { [weak self] in
        let authUseCase = DefaultAuthUseCase()
        let viewModel = PhoneNumberViewModel(authUseCase: authUseCase)
        viewModel.setActions(
            actions: PhoneNumberViewModelActions(
                showCertificationPage: self?.showCerfiticationPage
            )
        )
        
        let vc = PhoneNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)

    }
    
    lazy var showCerfiticationPage: (String) -> Void = { [weak self] phoneNumber in
        let authUseCase = DefaultAuthUseCase()
        let registerStateValidateUseCase = DefaultRegisterStateValidateUseCase()
        let loadDetailInfoUseCase = DefaultLoadDetailInfoUseCase()
        
        let viewModel = CertificationViewModel(
            authUseCase: authUseCase,
            registerStateValidateUseCase: registerStateValidateUseCase,
            loadDetailInfoUseCase: loadDetailInfoUseCase
        )
        viewModel.phoneNumber = phoneNumber
        
        viewModel.setActions(
            actions: CertificationViewModelActions(
                doneSignIn: self?.doneSignIn
            )
        )
        
        let vc = CertificationNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var doneSignIn: (RegisterState) -> Void = { [weak self] state in
        
        // 이부분 어칼지 상의
        self?.navigationController.popViewController(animated: false)
        self?.navigationController.popViewController(animated: false)

        
        switch state {
        case .none:
            let coordinator = RegisterCoordinator(navigationController: self?.navigationController ?? UINavigationController())
            coordinator.finishDelegate = self
            self?.childCoordinators.append(coordinator)
            coordinator.start()
        case .part(let registerUserInfo):
            let coordinator = RegisterCoordinator(navigationController: self?.navigationController ?? UINavigationController())
            coordinator.finishDelegate = self
            self?.childCoordinators.append(coordinator)
            coordinator.start(registerUserInfo: registerUserInfo)
            
        case .done:
            self?.finish()
        }
    }
}

enum RegisterState {
    case none
    case part(RegisterUserInfo)
    case done
}

extension AuthCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        
        if childCoordinator.type == .register {
            self.finish()
        }
    }
}
