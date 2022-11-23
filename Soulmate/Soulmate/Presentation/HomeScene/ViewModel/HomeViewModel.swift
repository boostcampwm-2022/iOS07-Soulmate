//
//  HomeViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import Foundation

struct HomeViewModelAction {
    var showDetailVC: (() -> Void)?
}

final class HomeViewModel {
    var actions: HomeViewModelAction?
    private weak var coordinator: HomeCoordinator?
    
    func setActions(actions: HomeViewModelAction) {
        self.actions = actions
    }
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
}

extension HomeViewModel {
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
