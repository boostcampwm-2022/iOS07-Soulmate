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
        navigationController.setNavigationBarHidden(true, animated: true)
        showHomeVC()
    }
    
    func showHomeVC() {
        let container = DIContainer.shared.container
        guard let vm = container.resolve(HomeViewModel.self) else { return }

        vm.setActions(
            actions: HomeViewModelAction(
                showDetailVC: showDetailVC
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
}
