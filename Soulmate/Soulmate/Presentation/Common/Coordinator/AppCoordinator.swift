//
//  AppCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import FirebaseAuth

final class AppCoordinator: Coordinator {
        
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
        
    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType = .app
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

    }
    
    func start() {
//        if Auth.auth().currentUser == nil {
//            showAuthFlow()
//        }
//        else {
//            showMainTabFlow()
//        }
        
//        showAuthFlow()
        
        chattingRoomTest()
    }
    
    private func chattingRoomTest() {
        let sendMesssageUseCase = DefaultSendMessageUseCase()
        let viewModel = ChattingRoomViewModel(
            sendMessageUseCase: sendMesssageUseCase
        )
        let vc = ChattingRoomViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.finishDelegate = self
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }
    
    private func showMainTabFlow() {
        let tabCoordinator = MainTabCoordinator(navigationController: navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        if childCoordinator.type == .auth {
            showMainTabFlow()
        }
    }
}
