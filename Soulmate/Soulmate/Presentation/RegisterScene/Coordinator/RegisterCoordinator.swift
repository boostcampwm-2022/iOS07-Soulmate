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
    
    func start() {
        let vm = RegisterViewModel()
        vm.setActions(
            actions: RegisterViewModelAction(
                quitRegister: quitRegister,
                finishRegister: finishRegister
            )
        )
        let vc = RegisterViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var finishRegister: () -> Void = { [weak self] in
        self?.finish()
        
        //성공했으니 홈으로 가도 좋다는 것을 전달해야함 어떻게??????????
    }
    
    lazy var quitRegister: () -> Void = { [weak self] in
        self?.finish()
        
        // 실패했으니 그냥 로그인 초기화면으로 이동하기
    }
}
