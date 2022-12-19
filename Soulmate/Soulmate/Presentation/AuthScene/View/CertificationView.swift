//
//  CertificationView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import UIKit
import SnapKit

final class CertificationNumberView: UIView {
    
    // MARK: - UI Components
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드를 \n입력해주세요"
        label.numberOfLines = 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 35.2
        paragraphStyle.minimumLineHeight = 35.2
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSMutableAttributedString(
            string: label.text ?? "",
            attributes: attr)
        label.attributedText = attrString
        var font = UIFont(name: "Apple SD Gothic Neo", size: 22)?.withWeight(700)
        var descriptor = font?.fontDescriptor
        label.font = font
        return label
    }()
    
    lazy var userPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "01012345678"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 22.4
        paragraphStyle.minimumLineHeight = 22.4
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSMutableAttributedString(
            string: label.text ?? "",
            attributes: attr)
        label.attributedText = attrString
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 14)?.withWeight(600)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var resendButton: UIButton = {
        let button = UIButton()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 22.4
        paragraphStyle.minimumLineHeight = 22.4
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 14)?.withWeight(700) ?? UIFont(),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSAttributedString(string: "재전송", attributes: attr)
        button.setAttributedTitle(attrString, for: .normal)
        
        return button
    }()
    
    private lazy var phoneNumAndResendButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        stackView.addArrangedSubview(userPhoneNumberLabel)
        stackView.addArrangedSubview(resendButton)
        
        return stackView
    }()
    
    private lazy var guideLabelAndPhoneNumberStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(guideLabel)
        stackView.addArrangedSubview(phoneNumAndResendButtonStackView)
        
        return stackView
    }()
    
    var certificationFields = [
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField()
    ]
    
    lazy var certificationFieldClearTouchView: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = .clear

        return view
    }()
    
    private lazy var numStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        self.addSubview(certificationFieldClearTouchView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        certificationFields.forEach { certificationField in
            let underLinedView = self.underLinedView(textField: certificationField)
            stackView.addArrangedSubview(underLinedView)
        }
                
        return stackView
    }()
    
    lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        self.addSubview(button)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

private extension CertificationNumberView {
    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        guideLabelAndPhoneNumberStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        numStackView.snp.makeConstraints {
            $0.top.equalTo(guideLabelAndPhoneNumberStackView.snp.bottom).offset(81)
            $0.centerX.equalToSuperview()
        }
        
        certificationFieldClearTouchView.snp.makeConstraints {
            $0.edges.equalTo(numStackView)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(54)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - View Generator

private extension CertificationNumberView {
    func underLinedView(textField: UITextField) -> UIStackView {
        let stackView = UIStackView()
        let numTextField = textField
        let underBar = UIView()
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .center
        numTextField.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        numTextField.textAlignment = .center
        underBar.widthAnchor.constraint(equalToConstant: 52).isActive = true
        underBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underBar.backgroundColor = .black
        stackView.addArrangedSubview(numTextField)
        stackView.addArrangedSubview(underBar)
        
        return stackView
    }
}
