//
//  HeartShopCoordinator.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/28.
//
import UIKit

class HeartShopCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .heartShop
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HeartShopViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
