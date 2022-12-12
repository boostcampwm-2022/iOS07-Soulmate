//
//  HomeCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        showHomeVC()
    }
    
    func showHomeVC() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(HomeViewModel.self) else { return }

        vm.setActions(
            actions: HomeViewModelAction(
                showDetailVC: showDetailVC,
                showHeartShopFlow: showHeartShopFlow
            )
        )
        let vc = HomeViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showDetailVC: (DetailPreviewViewModel) -> Void = { [weak self] detailPreviewViewModel in
        let container = DIContainer.shared.container
        guard let vm = container.resolve(DetailViewModel.self) else { return }
        
        vm.setActions(actions: DetailViewModelActions())
        vm.setUser(detailPreviewViewModel: detailPreviewViewModel)
        
        let vc = DetailViewController(viewModel: vm)
        
        self?.navigationController.present(vc, animated: true)
    }
    
    lazy var showHeartShopFlow: () -> Void = { [weak self] in
        let coordinator = HeartShopCoordinator(navigationController: self?.navigationController ?? UINavigationController())
        self?.childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
