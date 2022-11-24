//
//  RegisterCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import UIKit

class RegisterCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .register
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with registerUserInfo: RegisterUserInfo? = nil) {
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let networkKeyValueStorageApi = FirebaseNetworkKeyValueStorageApi()
        
        let profilePhotoRepository = DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        let userDetailInfoRepository = DefaultUserDetailInfoRepository(networkDatabaseApi: networkDatabaseApi)
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        
        let uploadDetailInfoUseCase = DefaultUploadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        let uploadPhotoUseCase = DefaultUpLoadPictureUseCase(profilePhotoRepository: profilePhotoRepository)
        let uploadPreviewUseCase = DefaultUploadPreviewUseCase(userPreviewRepository: userPreviewRepository)
        
        let vm = RegisterViewModel(
            uploadDetailInfoUseCase: uploadDetailInfoUseCase,
            uploadPictureUseCase: uploadPhotoUseCase,
            uploadPreviewUseCase: uploadPreviewUseCase
        )
        
        vm.setActions(
            actions: RegisterViewModelAction(
                quitRegister: quitRegister,
                finishRegister: finishRegister
            )
        )
        
        if let registerUserInfo = registerUserInfo {
            vm.setPrevRegisterInfo(registerUserInfo: registerUserInfo)
        }

        let vc = RegisterViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var finishRegister: () -> Void = { [weak self] in
        guard let authCoordinator = self?.finishDelegate as? AuthCoordinator else { return }
        self?.finish()
        authCoordinator.showMainTabFlow()
    }
    
    lazy var quitRegister: () -> Void = { [weak self] in // 애는 중간에 종료하는 경우, 이 경우는 그냥 원래 페이지로 옮겨주자
        self?.finish()
        let signoutUseCase = DefaultSignOutUseCase()
        guard let _ = try? signoutUseCase.signOut() else { return }
    }
}
