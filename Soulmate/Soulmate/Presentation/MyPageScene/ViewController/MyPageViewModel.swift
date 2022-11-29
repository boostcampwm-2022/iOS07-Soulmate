//
//  MyPageViewModel.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/23.
//

import Foundation
import Combine

struct MyPageViewModelActions {
    var showMyInfoEditFlow: ((RegisterUserInfo) -> Void)?
    var showPersonalInfoFlow: (() -> Void)?
    var showHeartShopFlow: (() -> Void)?
}

class MyPageViewModel {
    
    let symbols = ["myPageHeart", "myPagePersonalInfo", "myPagePin"]
    let titles = ["하트샵 가기", "개인정보 처리방침", "버전정보"]
    let subTexts = ["", "", "v 3.2.20"]
    
    private weak var coordinator: MyPageCoordinator?
    var actions: MyPageViewModelActions?
    var cancellables = Set<AnyCancellable>()
    
    struct Input {
        var didTappedMyInfoEditButton: AnyPublisher<Void, Never>
        var didTappedHeartShopButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var heartShopButtonTapped: AnyPublisher<Void, Never>
    }
    
    func setActions(actions: MyPageViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        return Output(heartShopButtonTapped: input.didTappedHeartShopButton)
    }
    
}
