//
//  DefaultChatCoordinator.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import UIKit

class DefaultChatCoordinator: ChatCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    
    var type: CoordinatorType = .chat
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loadChattingRoomListUseCase = DefaultLoadChattingRoomListUseCase()
        
        let networkKeyValueStorageApi = FirebaseNetworkKeyValueStorageApi()
        let profilePhotoRepository = DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        let imageCacheRepository = DefaultImageCacheRepository(imageCacheStorage: NSCacheImageCacheStorage.shared)
        let fetchImageUseCase = DefaultFetchImageUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
        
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let mateRequestRepository = DefaultMateRquestRepository(networkDatabaseApi: networkDatabaseApi)
        let authRepository = DefaultAuthRepository()
        let listenMateRequestUseCase = DefaultListenMateRequestUseCase(
            mateRequestRepository: mateRequestRepository,
            authRepository: authRepository
        )
        
                
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        let chatRoomRepository = DefaultChatRoomRepository(networkDatabaseApi: networkDatabaseApi)
        
        let acceptMateRequest = DefaultAcceptMateRequestUseCase(
            authRepository: authRepository,
            userPreviewRepository: userPreviewRepository,
            chatRoomRepository: chatRoomRepository,
            mateRequestRepository: mateRequestRepository
        )
        
        let chatRoomListViewModel = ChatRoomListViewModel(
            coordinator: self,
            loadChattingRoomListUseCase: loadChattingRoomListUseCase,
            fetchImageUseCase: fetchImageUseCase,
            authUseCase: DefaultAuthUseCase(),
            deleteChatRoomUseCase: DefaultDeleteChatRooMUseCase(chatRoomRepository: chatRoomRepository)
        )
        let chatRoomListVC = ChatRoomListViewController(viewModel: chatRoomListViewModel)
        
        let deleteMateRequest = DefaultDeleteMateRequestUseCase(mateRequestRepository: mateRequestRepository)
        
        let receivedChatRequestsViewModel = ReceivedChatRequestsViewModel(
            coordinator: self,
            listenMateRequestUseCase: listenMateRequestUseCase,
            fetchImageUseCase: fetchImageUseCase,
            acceptMateRequest: acceptMateRequest,
            deleteMateRequestUseCase: deleteMateRequest
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
        let urlSessionAPI = DefaultURLSessionAPI()
        let authRepository = DefaultAuthRepository()
        let chattingRepository = DefaultChattingRepository(authRepository: authRepository, networkDatabaseApi: networkDatabaseApi)
        let profilePhotoRepository = DefaultProfilePhotoRepository(
            networkKeyValueStorageApi: FirebaseNetworkKeyValueStorageApi()
        )
        let imageCacheRepository = DefaultImageCacheRepository(
            imageCacheStorage: NSCacheImageCacheStorage.shared
        )
        
        let enterStateRepository = DefaultEnterStateRepository(
            authRepository: authRepository,
            networkDatabaseApi: networkDatabaseApi
        )
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        let fcmRepository = DefaultFCMRepository(
            urlSessionAPI: urlSessionAPI,
            networkDatabaseApi: networkDatabaseApi
        )
        let sendMessageUseCase = DefaultSendMessageUseCase(
            with: info,
            chattingRepository: chattingRepository,
            authRepository: authRepository,
            enterStateRepository: enterStateRepository,
            fcmRepository: fcmRepository,
            userPreviewRepository: userPreviewRepository
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
        let listenOthersEnterStateUseCase = DefaultListenOthersEnterStateUseCase(
            with: info,
            enterStateRepository: enterStateRepository,
            authRepository: authRepository
        )
        let enterChatRoomUseCase = DefaultEnterChatRoomUseCase(
            with: info,
            enterStateRepository: enterStateRepository,
            authRepository: authRepository
        )
        
        let imageKeyUseCase = DefaultImageKeyUseCase()
        let fetchImageUseCase = DefaultFetchImageUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
        let fetchMatePreviewUseCase = DefaultFetchMatePreviewUseCase(
            info: info,
            userPreviewRepository: userPreviewRepository,
            authRepository: authRepository
        )
        
        let fetchMateChatImageKeyUseCase = DefaultFetchMateChatImageKeyUseCase(
            info: info,
            authRepository: authRepository,
            imageKeyUseCase: imageKeyUseCase
        )
        
        let viewModel = ChattingRoomViewModel(
            sendMessageUseCase: sendMessageUseCase,
            loadChattingsUseCase: loadChattingsUseCase,
            loadUnreadChattingsUseCase: loadUnreadChattingsUseCase,
            loadPrevChattingsUseCase: loadPrevChattingsUseCase,
            listenOthersChattingsUseCase: listenOthersChattingsUseCase,
            listenOthersEnterStateUseCase: listenOthersEnterStateUseCase,
            enterChatRoomUseCase: enterChatRoomUseCase,
            imageKeyUseCase: imageKeyUseCase,
            fetchImageUseCase: fetchImageUseCase,
            fetchMatePreviewUseCase: fetchMatePreviewUseCase,
            fetchMateChatImageKeyUseCase: fetchMateChatImageKeyUseCase
        )
        let viewController = ChattingRoomViewController(viewModel: viewModel, chatRoomInfo: info)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
