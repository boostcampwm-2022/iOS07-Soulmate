//
//  AuthCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

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
        let viewModel = LoginViewModel()
        viewModel.setActions(
            actions: LoginViewModelActions(
                showAppleLoginSheet: self?.showAppleLoginSheet,
                showPhoneLoginPage: self?.showPhoneLoginPage
            )
        )
        
        let vc = LoginViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showAppleLoginSheet: () -> Void = {}
    
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
        self?.showCerfiticationPage("")
        self?.doneCertificationPage(true)
    }
    
    lazy var showCerfiticationPage: (String) -> Void = { [weak self] phoneNumber in
        let authUseCase = DefaultAuthUseCase()
        let viewModel = CertificationViewModel(authUseCase: authUseCase)
        viewModel.phoneNumber = phoneNumber // 수정
        
        viewModel.setActions(
            actions: CertificationViewModelActions(
                doneCertification: self?.doneCertificationPage
            )
        )
        
        let vc = CertificationNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var doneCertificationPage: (Bool) -> Void = { [weak self] bool in
        
        self?.navigationController.popViewController(animated: false)
        self?.navigationController.popViewController(animated: false)


        let coordinator = RegisterCoordinator(navigationController: self?.navigationController ?? UINavigationController())
        coordinator.finishDelegate = self
        self?.childCoordinators.append(coordinator)
        coordinator.start()
    }
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
