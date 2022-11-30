//
//  ModificationPopUpView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/30.
//

import UIKit

class ModificationPopUpViewController: UIViewController {
    
    var containerView: UIView!
    
    var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(containerView: UIView) {
        self.init(nibName: nil, bundle: nil)
        self.containerView = containerView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        containerView.addSubview(dismissButton)
        //containerView.addSubview(adjustButton)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        containerView.layer.cornerRadius = 10
        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
//            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
//            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-84)
            $0.height.equalTo(500)
        }
        
        dismissButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(20)
        }
        
        dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
//        adjustButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.top.equalToSuperview().offset(20)
//            $0.width.height.equalTo(20)
//        }
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
}
