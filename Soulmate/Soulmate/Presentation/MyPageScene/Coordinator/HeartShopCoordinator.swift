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
        // TODO: 마이페이지로 돌아왔을때 보유하트 로드해야함..
    }
    
    func start(completionHandler: @escaping () -> Void) {
        let repo = DefaultUserPreviewRepository(networkDatabaseApi: FireStoreNetworkDatabaseApi())
        let usecase = DefaultHeartShopUseCase(userPreviewRepository: repo)
        let vm = HeartShopViewModel(heartShopUseCase: usecase)
        vm.setActions(
            actions: HeartShopViewModelActions(
                quitHeartShop: quitHeartShop,
                chargeFinished: chargeFinished
            )
        )
        vm.completionHandler = completionHandler
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
    
    lazy var chargeFinished: () -> Void = { [weak self] in
        self?.navigationController.dismiss(animated: true)
        self?.finish()
    }
}
