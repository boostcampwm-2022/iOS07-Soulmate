//
//  HomeCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHomeVC()
    }
    
    func showHomeVC() {
        let vm = HomeViewModel(coordinator: self)
        let vc = HomeViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showDetailVC() {
        // TODO: 정보 전달하기
        let userInfo = RegisterUserInfo()
        let distance = 0
        
        let vm = DetailViewModel(userInfo: userInfo, distance: distance, coordinator: self)
        let vc = DetailViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
