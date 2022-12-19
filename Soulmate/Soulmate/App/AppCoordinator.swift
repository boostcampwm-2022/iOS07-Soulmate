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
        
        UIView.transition(with: window,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func start() {
        //try? Auth.auth().signOut()
        
        // 코디네이터는 presentation 레이어인데 여기서 레포지토리를 꺼내써도 되는지? auth usecase를 따로 만들어야하나?
        let container = DIContainer.shared.container
        guard let authRepository = container.resolve(AuthRepository.self) else { return }
        
        if let uid = try? authRepository.currentUid() {
            checkRegistration(for: uid)
        } else {
            showAuthSignInFlow()
        }
    }
    
    private func checkRegistration(for uid: String) {
        Task {
            let container = DIContainer.shared.container
            guard let downloadDetailInfoUseCase = container.resolve(DownLoadDetailInfoUseCase.self),
                  let registerStateValidateUseCase = container.resolve(RegisterStateValidateUseCase.self) else { return }
            
            do {
                let userInfo = try await downloadDetailInfoUseCase.downloadDetailInfo(userUid: uid)
                let state = registerStateValidateUseCase.validateRegisterState(registerUserInfo: userInfo)
                
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
    
    func showAuthSignInFlow() {
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
    
    private func showAuthRegisterFlow(registerUserInfo: UserDetailInfo? = nil) {
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
    }
}
