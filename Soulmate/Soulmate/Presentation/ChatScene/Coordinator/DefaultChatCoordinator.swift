//
//  DefaultChatCoordinator.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import UIKit

class DefaultChatCoordinator: ChatCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    
    var type: CoordinatorType = .chat
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loadChattingRoomListUseCase = DefaultLoadChattingRoomListUseCase()
        let viewModel = ChatListViewModel(
            coordinator: self,
            loadChattingRoomListUseCase: loadChattingRoomListUseCase
        )
        let chatRoomListVC = ChatListViewController(viewModel: viewModel)
        
        let pageViewController = ChatScenePageViewController(chatRoomListViewController: chatRoomListVC)
        
        self.navigationController.pushViewController(pageViewController, animated: true)
    }
    
    func showChatRoom(with info: ChatRoomInfo) {
        let sendMessageUseCase = DefaultSendMessageUseCase(with: info)
        let loadChattingsUseCase = DefaultLoadChattingsUseCase(with: info)
        let viewModel = ChattingRoomViewModel(
            sendMessageUseCase: sendMessageUseCase,
            loadChattingsUseCase: loadChattingsUseCase
        )
        let viewController = ChattingRoomViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
