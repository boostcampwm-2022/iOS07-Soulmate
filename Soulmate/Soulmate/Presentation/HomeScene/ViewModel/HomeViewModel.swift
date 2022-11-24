//
//  HomeViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import Foundation
import Combine

struct HomeViewModelAction {
    var showDetailVC: (() -> Void)?
}

final class HomeViewModel {
    var actions: HomeViewModelAction?
    
    func setActions(actions: HomeViewModelAction) {
        self.actions = actions
    }

}
