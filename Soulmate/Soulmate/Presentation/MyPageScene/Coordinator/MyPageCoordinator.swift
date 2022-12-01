//
//  MyPageCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

class MyPageCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .myPage
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let networkKeyValueStorageApi = FirebaseNetworkKeyValueStorageApi()
        
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        let profilePhotoRepository = DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        let imageCacheRepository = DefaultImageCacheRepository(imageCacheStorage: NSCacheImageCacheStorage.shared)
        
        let downLoadPreviewUseCase = DefaultDownLoadPreviewUseCase(userPreviewRepository: userPreviewRepository)
        let downLoadPictureUseCase = DefaultDownLoadPictureUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
        
        let vm = MyPageViewModel(
            downLoadPreviewUseCase: downLoadPreviewUseCase,
            downLoadPictureUseCase: downLoadPictureUseCase
        )
        
        vm.setActions(
            actions: MyPageViewModelActions(
                showMyInfoEditFlow: showModificationVC,
                showServiceTermFlow: showServiceTermVC,
                showHeartShopFlow: showHeartShopVC,
                showDistanceFlow: showDistanceVC
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
        
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let networkKeyValueStorageApi = FirebaseNetworkKeyValueStorageApi()
        let imageCacheStorage = NSCacheImageCacheStorage.shared
        
        let userDetailInfoRepository = DefaultUserDetailInfoRepository(networkDatabaseApi: networkDatabaseApi)
        let profilePhotoRepository = DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        let imageCacheRepository = DefaultImageCacheRepository(imageCacheStorage: imageCacheStorage)
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        
        let downloadDetailInfoUseCase = DefaultDownLoadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        let downloadPictureUseCase = DefaultDownLoadPictureUseCase(
            profilePhotoRepository: profilePhotoRepository,
            imageCacheRepository: imageCacheRepository
        )
        let uploadDetailInfoUseCase = DefaultUploadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        let uploadPictureUseCase = DefaultUpLoadPictureUseCase(profilePhotoRepository: profilePhotoRepository)
        let uploadPreviewUseCase = DefaultUploadPreviewUseCase(userPreviewRepository: userPreviewRepository)
        
        
        let viewModel = ModificationViewModel(
            downloadDetailInfoUseCase: downloadDetailInfoUseCase,
            downloadPictureUseCase: downloadPictureUseCase,
            uploadDetailInfoUseCase: uploadDetailInfoUseCase,
            uploadPictureUseCase: uploadPictureUseCase,
            uploadPreviewUseCase: uploadPreviewUseCase
        )
        
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
        let vm = DistanceViewModel()
        let vc = DistanceViewController(viewModel: vm)
        self?.navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var didFinishModification: () -> Void = { [weak self] in
        self?.navigationController.popToRootViewController(animated: true)
    }
}

extension MyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
