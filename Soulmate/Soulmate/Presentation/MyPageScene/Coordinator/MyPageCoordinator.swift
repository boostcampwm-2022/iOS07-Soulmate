//
//  MyPageCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

class MyPageCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .myPage
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(MyPageViewModel.self) else { return }
        
        vm.setActions(
            actions: MyPageViewModelActions(
                showMyInfoEditFlow: showModificationVC,
                showServiceTermFlow: showServiceTermVC,
                showHeartShopFlow: showHeartShopVC,
                showDistanceFlow: showDistanceVC,
                showSignOutFlow: didSignOut
            )
        )
        let vc = MyPageViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showHeartShopVC: () -> Void = { [weak self] in
        let coordinator = HeartShopCoordinator(navigationController: self?.navigationController ?? UINavigationController())
        self?.childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    lazy var showModificationVC: (@escaping () -> Void) -> Void = { [weak self] completionHandler in
        
        let container = DIContainer.shared.container
        guard let viewModel = container.resolve(ModificationViewModel.self) else { return }
        
        viewModel.setActions(
            actions: ModificationViewModelActions(
                didFinishModification: self?.didFinishModification
            )
        )
        
        viewModel.completionHandler = completionHandler
        
        let vc = ModificationViewController(viewModel: viewModel)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showServiceTermVC: () -> Void = { [weak self] in
        let vc = ServiceTermViewController()
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showDistanceVC: () -> Void = { [weak self] in
        let container = DIContainer.shared.container
        guard let vm = container.resolve(DistanceViewModel.self) else { return }
        let vc = DistanceViewController(viewModel: vm)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var didFinishModification: () -> Void = { [weak self] in
        self?.navigationController.popToRootViewController(animated: true)
    }
    
    lazy var didSignOut: () -> Void = { [weak self] in
        guard let mainTabCoordinator = self?.finishDelegate as? MainTabCoordinator else { return }
        
        self?.finish()
        mainTabCoordinator.showAuthSignInFlow()
    }
}

extension MyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
