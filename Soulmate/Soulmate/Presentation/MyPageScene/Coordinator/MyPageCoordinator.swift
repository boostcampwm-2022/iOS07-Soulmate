//
//  MyPageCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

class MyPageCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .myPage
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = MyPageViewModel()
        let vc = MyPageViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
//    lazy var showPersonalInfoPage: () -> Void = { [weak self] in
//        let viewModel = MyPageViewModel()
//    }()
}
