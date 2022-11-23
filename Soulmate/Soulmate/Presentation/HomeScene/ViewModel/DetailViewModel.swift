//
//  DetailViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/21.
//

import Foundation

struct DetailViewModelAction {
    var showChatListVC: (() -> Void)?
}

final class DetailViewModel {
    let userInfo: RegisterUserInfo
    let distance: Int
    var actions: DetailViewModelAction?
    private weak var coordinator: HomeCoordinator?
    
    init(userInfo: RegisterUserInfo, distance: Int, coordinator: HomeCoordinator) {
        self.userInfo = userInfo
        self.distance = distance
        self.coordinator = coordinator
    }
    
    func setActions(actions: DetailViewModelAction) {
        self.actions = actions
    }
    
}

extension DetailViewModel {
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
