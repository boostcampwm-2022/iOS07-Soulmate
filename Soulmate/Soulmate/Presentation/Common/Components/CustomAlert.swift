//
//  CustomAlert.swift
//  Soulmate
//
//  Created by termblur on 2022/12/08.
//

import UIKit

import SnapKit

final class CustomAlert: UIViewController {
    private var titleText: String
    private var messageText: String
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 12
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 14
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = .labelDarkGrey
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - init
    init(titleText: String, messageText: String) {
        self.titleText = titleText
        self.messageText = messageText
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    // MARK: - setup
    private func configure() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(messageLabel)
        containerStackView.addArrangedSubview(buttonStackView)
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.top.greaterThanOrEqualToSuperview().inset(32)
            $0.bottom.lessThanOrEqualToSuperview().inset(32)
        }

        containerStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(containerView).inset(24)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(containerStackView.snp.width)
        }
    }
    
    // MARK: - methods
    public func addActionToButton(title: String? = nil,
                                  titleColor: UIColor = .white,
                                  backgroundColor: UIColor = .mainPurple ?? .blue,
                                  completion: (() -> Void)? = nil) {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)
        
        button.layer.cornerRadius = 6.0
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        
        let action = UIAction { _ in
            completion?()
        }
        button.addAction(action, for: .touchUpInside)

        buttonStackView.addArrangedSubview(button)
    }
}

// MARK: - extensions
extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIViewController {
    func showPopUp(title: String,
                   message: String,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let customAlert = CustomAlert(titleText: title,
                                      messageText: message)
        showPopUp(customAlert: customAlert,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    private func showPopUp(customAlert: CustomAlert,
                           leftActionTitle: String,
                           rightActionTitle: String,
                           leftActionCompletion: (() -> Void)?,
                           rightActionCompletion: (() -> Void)?) {
        customAlert.addActionToButton(title: leftActionTitle,
                                      titleColor: .white,
                                      backgroundColor: .borderPurple ?? .systemGray2) {
            customAlert.dismiss(animated: false, completion: leftActionCompletion)
        }
        
        customAlert.addActionToButton(title: rightActionTitle,
                                      titleColor: .white,
                                      backgroundColor: .gradientPurple ?? .blue) {
            customAlert.dismiss(animated: false, completion: rightActionCompletion)
        }
        present(customAlert, animated: false, completion: nil)
    }
}
