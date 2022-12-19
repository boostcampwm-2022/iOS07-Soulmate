//
//  RegisterCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import UIKit

class RegisterCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var registerViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .register
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with registerUserInfo: UserDetailInfo? = nil) {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(RegisterViewModel.self) else { return }
        
        vm.setActions(
            actions: RegisterViewModelAction(
                quitRegister: quitRegister,
                finishRegister: finishRegister
            )
        )
        vm.setPrevRegisterInfo(registerUserInfo: registerUserInfo)
        
        let vc = RegisterViewController(viewModel: vm)

        navigationController.pushViewController(vc, animated: true)
        self.registerViewController = vc
    }
    
    func setPreNavigationStack(viewControllers: [UIViewController]) {
        guard let vc = self.registerViewController else { return }
        navigationController.setViewControllers(viewControllers + [vc], animated: true)        
    }
    
    lazy var finishRegister: () -> Void = { [weak self] in
        guard let authCoordinator = self?.finishDelegate as? AuthCoordinator else { return }
        self?.finish()
        authCoordinator.showMainTabFlow()
    }
    
    lazy var quitRegister: () -> Void = { [weak self] in // 이전버튼 계속 눌러서 홈으로 나갈 경우, 이 경우는 팝은 딱히 필요 없음
        self?.finish()
        
        let container = DIContainer.shared.container
        guard let signOutUseCase = container.resolve(SignOutUseCase.self) else { return }
        guard let _ = try? signOutUseCase.signOut() else { return }
    }
}
