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
    
    func start() {
        let profilePhotoRepository = DefaultProfilePhotoRepository()
        
        let uploadDetailInfoUseCase = DefaultUploadDetailInfoUseCase()
        let uploadPhotoUseCase = DefaultUpLoadPictureUseCase(profilePhotoRepository: profilePhotoRepository)
        let vm = RegisterViewModel(
            uploadDetailInfoUseCase: uploadDetailInfoUseCase,
            uploadPictureUseCase: uploadPhotoUseCase
        )
        vm.setActions(
            actions: RegisterViewModelAction(
                quitRegister: quitRegister,
                finishRegister: finishRegister
            )
        )
        let vc = RegisterViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    // 스타트 메서드 하나로 통합하기
    func start(registerUserInfo: RegisterUserInfo) {
        let profilePhotoRepository = DefaultProfilePhotoRepository()
        
        let uploadDetailInfoUseCase = DefaultUploadDetailInfoUseCase()
        let uploadPhotoUseCase = DefaultUpLoadPictureUseCase(profilePhotoRepository: profilePhotoRepository)
        let vm = RegisterViewModel(
            uploadDetailInfoUseCase: uploadDetailInfoUseCase,
            uploadPictureUseCase: uploadPhotoUseCase
        )
        
        vm.setPrevRegisterInfo(registerUserInfo: registerUserInfo)
        
        let vc = RegisterViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }

    
    lazy var finishRegister: () -> Void = { [weak self] in
        self?.finish()
    }
    
    lazy var quitRegister: () -> Void = { [weak self] in
        self?.finish()
        
        // 실패했으니 그냥 로그인 초기화면으로 이동하기
    }
}
