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
    
    deinit {
        print("heartshop deinited")
    }
    
    func start() {
        let vm = HeartShopViewModel()
        vm.setActions(actions: HeartShopViewModelActions(quitHeartShop: quitHeartShop))
        let vc = HeartShopViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController.topViewController?.present(nav, animated: true)
    }
    
    lazy var quitHeartShop: () -> Void = { [weak self] in
        self?.finish()
    }
}
