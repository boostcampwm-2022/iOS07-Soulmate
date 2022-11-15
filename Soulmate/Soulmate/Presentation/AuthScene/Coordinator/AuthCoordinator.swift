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
        let viewModel = PhoneNumberViewModel()
        viewModel.setActions(
            actions: PhoneNumberViewModelActions(
                showCertificationPage: self?.showCerfiticationPage
            )
        )
        
        let vc = PhoneNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showCerfiticationPage: (String) -> Void = { [weak self] phoneNumber in
        let viewModel = CertificationViewModel()
        viewModel.phoneNumber = phoneNumber // 수정
        
        viewModel.setActions(
            actions: CertificationViewModelActions(
                doneCertification: self?.doneCertificationPage
            )
        )
        
        let vc = CertificationNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var doneCertificationPage: (Bool) -> Void = { bool in
        
    }
}
