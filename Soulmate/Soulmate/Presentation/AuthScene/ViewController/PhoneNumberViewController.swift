//
//  PhoneNumberViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit
import Then
import SnapKit
class PhoneNumberViewController: UIViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님의 휴대폰번호를\n입력해주세요"
        label.numberOfLines = 2
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "본인의 휴대폰 번호를 입력해주세요."
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    let nationCodeDropDown: UITextField = {
        let textField = UITextField()
        textField.placeholder = "US +1"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.isEnabled = false
        return textField
    }()
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "01012345678"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    let nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        button.isEnabled = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.addUnderLine()
        nationCodeDropDown.addUnderLine()
    }
    func setLayout() {
        [titleLabel, descriptionLabel, nationCodeDropDown, phoneNumberTextField, nextButton].forEach { view.addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalTo(titleLabel.snp.left)
        }
        nationCodeDropDown.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(86)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(86)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            $0.width.equalTo(216)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(54)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

extension UITextField {
    func addUnderLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height + 3, width: self.bounds.width, height: 2.5)
        bottomLine.backgroundColor = UIColor.systemGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
