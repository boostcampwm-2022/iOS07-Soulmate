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
    var progressBarNavigationController: ProgressBarNavigationController?
    var navigationDelegate: UINavigationControllerDelegate?
    var registerNavigation: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .register
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = RegisterSelectableViewModel(registerUserInfo: RegisterUserInfo())
        vm.setType(type: GenderType.self)
        vm.setActions(actions: RegisterViewModelActions(nextStep: showPage2nd))
        let vc = RegisterSelectableViewController(viewModel: vm)
        navigationDelegate = vc
        registerNavigation = UINavigationController(rootViewController: vc)
        registerNavigation?.delegate = navigationDelegate
        
        
//        let progressVC = ProgressBarNavigationController(rootViewController: vc)
//        self.progressBarNavigationController = progressVC
//        progressVC.modalPresentationStyle = .fullScreen

//        navigationController.present(vc, animated: true)
        registerNavigation?.modalPresentationStyle = .fullScreen
        
        if let registerNavigation {
            self.navigationController.present(registerNavigation, animated: true)
        }
        
//        self.navigationController.pushViewController(vc, animated: true)
    }

    lazy var showPage2nd: (RegisterUserInfo) -> Void = { [weak self] info in
        let vm = RegisterNickNameViewModel(registerUserInfo: info)
        vm.setActions(actions: RegisterViewModelActions(nextStep: self?.showPage3rd))
        let vc = NicknameSettingViewController(viewModel: vm)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var showPage3rd: (RegisterUserInfo) -> Void = { [weak self] info in
        let vm = RegisterHeightViewModel(registerUserInfo: info)
        vm.setActions(actions: RegisterViewModelActions(nextStep: self?.showPage4th))
        let vc = HeightViewController(viewModel: vm)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var showPage4th: (RegisterUserInfo) -> Void = { [weak self] info in
        let vm = RegisterBirthViewModel(registerUserInfo: info)
        vm.setActions(actions: RegisterViewModelActions(nextStep: self?.showPage5th))
        let vc = BirthViewController(viewModel: vm)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var showPage5th: (RegisterUserInfo) -> Void = { [weak self] info in
        let vm = RegisterSelectableViewModel(registerUserInfo: info)
        vm.setType(type: SmokingType.self)
        vm.setActions(actions: RegisterViewModelActions(nextStep: self?.showPage6th))
        let vc = RegisterSelectableViewController(viewModel: vm)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var showPage6th: (RegisterUserInfo) -> Void = { [weak self] info in
        let vm = RegisterSelectableViewModel(registerUserInfo: info)
        vm.setType(type: DrinkingType.self)
        vm.setActions(actions: RegisterViewModelActions(nextStep: self?.showPage7th))
        let vc = RegisterSelectableViewController(viewModel: vm)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var showPage7th: (RegisterUserInfo) -> Void = { [weak self] info in
        let vm = RegisterIntroductionViewModel(registerUserInfo: info)
        vm.setActions(actions: RegisterViewModelActions(nextStep: self?.showPage8th))
        let vc = IntroductionSettingViewController(viewModel: vm)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var showPage8th: (RegisterUserInfo) -> Void = { [weak self] info in
        let vc = CongraturationsViewController()
        vc.actions = RegisterViewModelActions(nextStep: self?.doneRegister)
        self?.registerNavigation?.pushViewController(vc, animated: true)
    }
    
    lazy var doneRegister: (RegisterUserInfo) -> Void = { [weak self] info in
//        self?.progressBarNavigationController?.dismiss(animated: true)
        self?.finish()
    }
}
