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
//        let vm = HomeViewModel(coordinator: self)
//        let vc = HomeViewController(viewModel: vm)
//        //navigationController.viewControllers.removeAll()
//        navigationController.pushViewController(vc, animated: true)
        
        let vm = HomeViewModel()
        let vc = HomeViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showDetailVC() -> UIViewController {
        // TODO: 정보 전달하기
        //let userInfo = RegisterUserInfo()
        
        // 테스트 데이터
        let testData = RegisterUserInfo(
            gender: GenderType.male,
            nickName: "테스트",
            birthDay: Date(),
            height: 175,
            mbti: Mbti(innerType: InnerType.i, recognizeType: RecognizeType.n, judgementType: JudgementType.t, lifeStyleType: LifeStyleType.p),
            smokingType: SmokingType.often,
            drinkingType: DrinkingType.rarely,
            aboutMe: "하아라어랴아 러야마얼 야라으마야 라야으라 야을 매야라 으랴 아르 얌로야 ㅡ 라얄오 ㅏ으 랴이라 야므 라야라 만아랴 으마야러 아먀아르 만아라 으망랑 러 ㅁㄴ아랑마라야르 하아 라어랴아러 야마얼야 라으마야 라야으라 야을매야라 으랴 아르 얌로야 ㅡ 라얄오 ㅏ으 랴이라 야므 라야라 만아 랴 으마야러 아먀아르 만아라 으망랑러 ㅁㄴ아랑마라야르 ",
            imageList: ["heart", "logo", "Phone", "checkOn"])

        let distance = 11

        let vm = DetailViewModel(userInfo: testData, distance: distance, coordinator: self)
        let vc = DetailViewController(viewModel: vm)
        return vc
        
    }
}
