//
//  MainTabCoordinator.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import Foundation

import UIKit

enum TabBarPage: Int, CaseIterable {
    case home = 0
    case chat = 1
    case myPage = 2
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "채팅"
        case .myPage:
            return "내정보"
        }
    }
    
    func pageTabIcon() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .chat:
            return UIImage(systemName: "magnifyingglass")
        case .myPage:
            return UIImage(systemName: "text.justify")
        }
    }
}

final class MainTabCoordinator: NSObject, Coordinator {
    
    var locationService: CLLocationService?
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    private var tabBarController: UITabBarController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .tab
    
    private var currentPage: TabBarPage = .home
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func configureLocationService() {
        let networkDatabaseApi = FireStoreNetworkDatabaseApi()
        let userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        let uploadLocationUseCase = DefaultUpLoadLocationUseCase(userPreviewRepository: userPreviewRepository)
        self.locationService = CLLocationService(upLoadLocationUseCase: uploadLocationUseCase)
    }
    
    func start() {
        configureLocationService()
        
        let pages = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map { getTabController($0) }
    
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.rawValue
        tabBarController.tabBar.isTranslucent = false
        tabBarController.delegate = self
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigation = UINavigationController()
        
        navigation.tabBarItem = UITabBarItem.init(
            title: page.pageTitleValue(),
            image: page.pageTabIcon(),
            tag: page.rawValue
        )

        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigation)
            homeCoordinator.finishDelegate = self
            childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .chat:
            let chatCoordinator = DefaultChatCoordinator(navigationController: navigation)
            chatCoordinator.finishDelegate = self
            childCoordinators.append(chatCoordinator)
            chatCoordinator.start()
        case .myPage:
            let myPageCoordinator = MyPageCoordinator(navigationController: navigation)
            myPageCoordinator.finishDelegate = self
            childCoordinators.append(myPageCoordinator)
            myPageCoordinator.start()
        }
        
        return navigation
    }
}

extension MainTabCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}

extension MainTabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == currentPage.rawValue {
            childCoordinators[tabBarController.selectedIndex].childCoordinators = []
        } else {
            guard let newPage = TabBarPage(rawValue: tabBarController.selectedIndex) else { return }
            currentPage = newPage
        }
    }
}
