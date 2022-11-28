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
    
    var window: UIWindow
        
    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType = .app
            
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {

        if let uid = Auth.auth().currentUser?.uid {
            checkRegistration(for: uid)
        }
        else {
            showAuthSignInFlow()
        }
//        showMyPageFlow()
    }
    
    private func checkRegistration(for uid: String) {
        Task {
            let networkDatabseApi = FireStoreNetworkDatabaseApi()
            let userDetailInfoRepository = DefaultUserDetailInfoRepository(networkDatabaseApi: networkDatabseApi)
            var downloadDetailInfoUseCase = DefaultDownLoadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
            var registerStateValidateUseCase = DefaultRegisterStateValidateUseCase()
            
            do {
                let userInfo = try await downloadDetailInfoUseCase.downloadDetailInfo(userUid: uid)
                let state = registerStateValidateUseCase.validateRegisterState(registerUserInfo: userInfo)
                
                print(userInfo)

                switch state {
                case .part:
                    await MainActor.run { showAuthRegisterFlow(registerUserInfo: userInfo) }
                case .done:
                    await MainActor.run { showMainTabFlow() }
                }
            }
            catch DecodingError.valueNotFound {
                await MainActor.run { showAuthRegisterFlow() }
            }
        }
    }
    
    private func showMyPageFlow() {
        let navigation = UINavigationController()
        window.rootViewController = navigation
        
        let authCoordinator = MyPageCoordinator(navigationController: navigation)
        authCoordinator.finishDelegate = self
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
        
        window.makeKeyAndVisible()
    }
    
    private func showAuthSignInFlow() {
        let navigation = UINavigationController()
        window.rootViewController = navigation
        
        let authCoordinator = AuthCoordinator(navigationController: navigation)
        authCoordinator.finishDelegate = self
        authCoordinator.start(with: .login)
        childCoordinators.append(authCoordinator)
        
        window.makeKeyAndVisible()
    }
    
    func showMainTabFlow() {
        let navigation = UINavigationController()
        window.rootViewController = navigation

        let tabCoordinator = MainTabCoordinator(navigationController: navigation)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
        
        window.makeKeyAndVisible()
    }
    
    private func showAuthRegisterFlow(registerUserInfo: RegisterUserInfo? = nil) {        
        let navigation = UINavigationController()
        window.rootViewController = navigation
        
        let authCoordinator = AuthCoordinator(navigationController: navigation)
        authCoordinator.finishDelegate = self
        authCoordinator.start(with: .register(registerUserInfo))
        childCoordinators.append(authCoordinator)
        
        window.makeKeyAndVisible()
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
