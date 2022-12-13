//
//  PhoneLoginCoorinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import UIKit

class PhoneLoginCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .auth
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showPhoneLoginPage()
    }
    
    
    lazy var showPhoneLoginPage: () -> Void = { [weak self] in
        let container = DIContainer.shared.container
        guard let viewModel = container.resolve(PhoneNumberViewModel.self) else { return }
        
        viewModel.setActions(
            actions: PhoneNumberViewModelActions(
                showCertificationPage: self?.showCerfiticationPage,
                quitPhoneLoginFlow: self?.quitPhoneLoginFlow
            )
        )
        
        let vc = PhoneNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showCerfiticationPage: (String) -> Void = { [weak self] phoneNumber in
        let container = DIContainer.shared.container
        guard let viewModel = container.resolve(CertificationViewModel.self) else { return }
        
        viewModel.phoneNumber = phoneNumber
        viewModel.setActions(
            actions: CertificationViewModelActions(
                showRegisterFlow: self?.showRegisterFlow,
                showMainTabFlow: self?.showMainTabFlow
            )
        )

        let vc = CertificationNumberViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showRegisterFlow: (RegisterUserInfo?) -> Void = { [weak self] registerUserInfo in
        guard let authCoordinator = self?.finishDelegate as? AuthCoordinator else { return }
        
        self?.finish()
        authCoordinator.showRegisterFlow(registerUserInfo)
    }
    
    lazy var showMainTabFlow: () -> Void = { [weak self] in
        guard let authCoordinator = self?.finishDelegate as? AuthCoordinator else { return }
        
        self?.finish()
        authCoordinator.showMainTabFlow()
    }
    
    lazy var quitPhoneLoginFlow: () -> Void = { [weak self] in
        self?.finish()
    }

}
