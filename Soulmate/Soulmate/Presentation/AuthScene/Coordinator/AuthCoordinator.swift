//
//  AuthCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import FirebaseAuth

class AuthCoordinator: Coordinator {
    
    enum AuthInitType {
        case login
        case register(RegisterUserInfo?)
    }
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .auth
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with `type`: AuthInitType) {
        switch `type` {
        case .login: showLoginPage()
        case .register(let registerUserInfo):
            showLoginPage() // 류트뷰를 로그인뷰컨으로 잡아둬서 나중에 뒤로가면 로그인 페이지로 돌아올수있도록
            showRegisterFlow(registerUserInfo)
        }
    }
    
    lazy var showLoginPage: () -> Void = { [weak self] in
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let userDetailInfoRepository = DefaultUserDetailInfoRepository(networkDatabaseApi: networkDatabaseApi)
        let downloadDetailInfoUseCase = DefaultDownLoadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        let registerDetailInfoUseCase = DefaultRegisterStateValidateUseCase()
        
        let viewModel = LoginViewModel(
            downLoadDetailInfoUseCase: downloadDetailInfoUseCase,
            registerStateValidateUseCase: registerDetailInfoUseCase
        )
        viewModel.setActions(
            actions: LoginViewModelActions(
                showRegisterFlow: self?.showRegisterFlow,
                showMainTabFlow: self?.showMainTabFlow,
                showPhoneLoginFlow: self?.showPhoneLoginFlow
            )
        )
        
        let vc = LoginViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showPhoneLoginFlow: () -> Void = { [weak self] in
        let coordinator = PhoneLoginCoordinator(navigationController: self?.navigationController ?? UINavigationController())
        coordinator.finishDelegate = self
        self?.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    lazy var showRegisterFlow: (RegisterUserInfo?) -> Void = { [weak self] registerUserInfo in
        let coordinator = RegisterCoordinator(navigationController: self?.navigationController ?? UINavigationController())
        coordinator.finishDelegate = self
        self?.childCoordinators.append(coordinator)
        coordinator.start(with: registerUserInfo)
    }
    
    lazy var showMainTabFlow: () -> Void = { [weak self] in
        guard let appCoordinator = self?.finishDelegate as? AppCoordinator else { return }
        
        appCoordinator.showMainTabFlow()
    }
}

enum RegisterState {
    case part
    case done
}

extension AuthCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
