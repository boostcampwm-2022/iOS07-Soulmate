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
        
    
        let imageCacheStorage = NSCacheImageCacheStorage()
        let imageCacheRepository = DefaultImageCacheRepository(imageCacheStorage: imageCacheStorage)
        let downloadPictureUseCase = DefaultDownLoadPictureUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
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
    
    lazy var showDetailVC: (UserPreview) -> Void = { [weak self] userPreview in
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let networkKeyValueStorageApi = FirebaseNetworkKeyValueStorageApi()
        let imageCacheStorage = NSCacheImageCacheStorage()
        let userDetailInfoRepository = DefaultUserDetailInfoRepository(networkDatabaseApi: networkDatabaseApi)
        let profilePhotoRepository = DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        let imageCacheRepository = DefaultImageCacheRepository(imageCacheStorage: imageCacheStorage)
        let downloadDetailInfoUseCase = DefaultDownLoadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        let downloadPictureUseCase = DefaultDownLoadPictureUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
        
        let vm = DetailViewModel(
            downloadPictureUseCase: downloadPictureUseCase,
            downloadDetailInfoUseCase: downloadDetailInfoUseCase
        )
        vm.setActions(actions: DetailViewModelActions())
        vm.setUser(userPreview: userPreview)
        
        let vc = DetailViewController(viewModel: vm)
        
        self?.navigationController.present(vc, animated: true)
    }
}
