//
//  PhoneNumberView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import UIKit
import SnapKit
import Combine

final class PhoneNumberView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님의 휴대폰번호를\n입력해주세요"
        label.numberOfLines = 2
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        self.addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "본인의 휴대폰 번호를 입력해주세요."
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        self.addSubview(label)
        return label
    }()
    
    lazy var nationCodeDropDown: UITextField = {
        let textField = UITextField()
        textField.placeholder = "US +1"
        textField.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(textField)
        return textField
    }()
    
    lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "01012345678"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.keyboardType = .numberPad
        self.addSubview(textField)
        return textField
    }()
    
    lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        button.isEnabled = false
        self.addSubview(button)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PhoneNumberView {
    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalTo(titleLabel.snp.left)
        }
        nationCodeDropDown.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(86)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(30)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(86)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-30)
            $0.width.equalTo(216)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(54)
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
    }
}
