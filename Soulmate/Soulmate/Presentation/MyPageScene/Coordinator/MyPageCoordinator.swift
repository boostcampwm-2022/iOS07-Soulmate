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
        vm.setActions(
            actions: MyPageViewModelActions(
                showMyInfoEditFlow: showModificationVC,
                showServiceTermFlow: showServiceTermVC,
                showHeartShopFlow: showHeartShopVC,
                showDistanceFlow: showDistanceVC
            )
        )
        let vc = MyPageViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showHeartShopVC: () -> Void = { [weak self] in
        let vc = HeartShopViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self?.navigationController.topViewController?.present(nav, animated: true)
    }
    
    lazy var showModificationVC: () -> Void = { [weak self] in
        let vc = ModificationViewController()
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showServiceTermVC: () -> Void = { [weak self] in
        let vc = ServiceTermViewController()
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showDistanceVC: () -> Void = { [weak self] in
        let vm = DistanceViewModel()
        let vc = DistanceViewController(viewModel: vm)
        self?.navigationController.pushViewController(vc, animated: true)
    }
}
