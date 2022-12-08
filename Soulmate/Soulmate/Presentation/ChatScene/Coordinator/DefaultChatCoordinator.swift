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
        let chatRoomListViewModel = ChatRoomListViewModel(
            coordinator: self,
            loadChattingRoomListUseCase: loadChattingRoomListUseCase,
            authUseCase: DefaultAuthUseCase()
        )
        let chatRoomListVC = ChatRoomListViewController(viewModel: chatRoomListViewModel)
        
        let loadReceivedChatRequestsUseCase = DefaultLoadReceivedChatRequestsUseCase()
        let receivedChatRequestsViewModel = ReceivedChatRequestsViewModel(
            coordinator: self,
            loadReceivedChatRequestsUseCase: loadReceivedChatRequestsUseCase
        )
        let receivedChatRequestsVC = ReceivedChatRequestsViewController(viewModel: receivedChatRequestsViewModel)
        
        let pageViewController = ChatScenePageViewController(
            chatRoomListViewController: chatRoomListVC,
            receivedChatRequestsViewController: receivedChatRequestsVC
        )
        
        self.navigationController.pushViewController(pageViewController, animated: true)
    }
    
    func showChatRoom(with info: ChatRoomInfo) {
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let authRepository = DefaultAuthRepository()
        let chattingRepository = DefaultChattingRepository(authRepository: authRepository, networkDatabaseApi: networkDatabaseApi)
        let profilePhotoRepository = DefaultProfilePhotoRepository(
            networkKeyValueStorageApi: FirebaseNetworkKeyValueStorageApi()
        )
        let imageCacheRepository = DefaultImageCacheRepository(
            imageCacheStorage: NSCacheImageCacheStorage.shared
        )
        let sendMessageUseCase = DefaultSendMessageUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository
        )
        let loadChattingsUseCase = DefaultLoadChattingsUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository
        )
        let loadUnreadChattingsUseCase = DefaultLoadUnreadChattingsUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository
        )
        let loadPrevChattingsUseCase = DefaultLoadPrevChattingsUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository
        )
        let listenOthersChattingsUseCase = DefaultListenOthersChattingUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository
        )
        let listenOtherIsReadingUseCase = DefaultListenOtherIsReadingUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository
        )
        let imageKeyUseCase = DefaultImageKeyUseCase()
        let fetchImageUseCase = DefaultFetchImageUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
        
        let viewModel = ChattingRoomViewModel(
            sendMessageUseCase: sendMessageUseCase,
            loadChattingsUseCase: loadChattingsUseCase,
            loadUnreadChattingsUseCase: loadUnreadChattingsUseCase,
            loadPrevChattingsUseCase: loadPrevChattingsUseCase,
            listenOthersChattingsUseCase: listenOthersChattingsUseCase,
            listenOtherIsReadingUseCase: listenOtherIsReadingUseCase,
            imageKeyUseCase: imageKeyUseCase,
            fetchImageUseCase: fetchImageUseCase
        )
        let viewController = ChattingRoomViewController(viewModel: viewModel, chatRoomInfo: info)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
