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
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        
        let localKeyValueStorage = UserDefaulsLocalKeyValueStorage()
        let userDefaultsRepository = DefaultUserDefaultsRepository(localKeyValueStorage: localKeyValueStorage)
        
        let mateRecommendationUseCase = DefaultMateRecommendationUseCase(
            userPreviewRepository: userPreviewRepository,
            userDefaultsRepository: userDefaultsRepository
        )
        
        let networkKeyValueStorageApi = FirebaseNetworkKeyValueStorageApi()
        let profilePhotoRepository = DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        
        let downloadPictureUseCase = DefaultDownLoadPictureUseCase(profilePhotoRepository: profilePhotoRepository)
        let vm = HomeViewModel(
            mateRecommendationUseCase: mateRecommendationUseCase,
            downloadPictureUseCase: downloadPictureUseCase
        )
        vm.setActions(
            actions: HomeViewModelAction(
                showDetailVC: showDetailVC
            )
        )
        let vc = HomeViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var showDetailVC: (String) -> Void = { [weak self] uid in
        
    }
}
