//
//  ProgressBarNavigationController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import UIKit
import SnapKit

class ProgressBarNavigationController: UINavigationController {

    let progressView = ProgressBar(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureLayout()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        progressView.goToNextStep()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        progressView.goToExStep()
        return super.popViewController(animated: animated)
    }
    
    func configureView() {
        view.backgroundColor = .clear
        view.addSubview(progressView)
    }
    
    func configureLayout() {
        progressView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }

}
