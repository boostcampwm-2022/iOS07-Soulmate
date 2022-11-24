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
}

class MyPageViewModel {
    
    private weak var coordinator: MyPageCoordinator?
    
    struct Input {
        var didTappedMyInfoEditButton: AnyPublisher<Void, Never>
        var didTappedHeartShopButton: AnyPublisher<Void, Never>
//        var didTappedPersonalInfoButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
    }
    
    var actions: MyPageViewModelActions?
    
    var cancellables = Set<AnyCancellable>()
    
    func setActions(actions: MyPageViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didTappedHeartShopButton
            .sink {
            }
            .store(in: &cancellables)
        return Output()
    }
    
}
