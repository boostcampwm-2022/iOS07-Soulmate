//
//  RegisterCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import UIKit

class RegisterCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .register
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with registerUserInfo: RegisterUserInfo? = nil) {

        let container = DIContainer.shared.container
        guard let vm = container.resolve(RegisterViewModel.self) else { return }
        
        vm.setActions(
            actions: RegisterViewModelAction(
                quitRegister: quitRegister,
                finishRegister: finishRegister
            )
        )
        
        if let registerUserInfo = registerUserInfo {
            vm.setPrevRegisterInfo(registerUserInfo: registerUserInfo)
        }

        let vc = RegisterViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var finishRegister: () -> Void = { [weak self] in
        guard let authCoordinator = self?.finishDelegate as? AuthCoordinator else { return }
        self?.finish()
        authCoordinator.showMainTabFlow()
    }
    
    lazy var quitRegister: () -> Void = { [weak self] in // 애는 중간에 종료하는 경우, 이 경우는 그냥 원래 페이지로 옮겨주자
        self?.finish()
        
        let container = DIContainer.shared.container
        guard let signOutUseCase = container.resolve(SignOutUseCase.self) else { return }
        guard let _ = try? signOutUseCase.signOut() else { return }
    }
}
