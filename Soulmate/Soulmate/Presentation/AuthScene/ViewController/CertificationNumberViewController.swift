//
//  CertificationNumberViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit

// TODO: Font Extension 나중에 분리해야 함
extension UIFont {
    
    func withWeight(_ weight: CGFloat) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = Weight(weight)
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

class CertificationNumberViewController: UIViewController {
    
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
    
    private lazy var userPhoneNumberLabel: UILabel = {
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
        // TODO: 색 올바르게 조정해야 함
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
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(guideLabel)
        stackView.addArrangedSubview(phoneNumAndResendButtonStackView)
        
        return stackView
    }()
    
    private lazy var firstNum: UIStackView = {
        numberView()
    }()
    private lazy var secondNum: UIStackView = {
        numberView()
    }()
    private lazy var thirdNum: UIStackView = {
        numberView()
    }()
    private lazy var fourthNum: UIStackView = {
        numberView()
    }()
    private lazy var fifthNum: UIStackView = {
        numberView()
    }()
    private lazy var sixthNum: UIStackView = {
        numberView()
    }()
    
    // TODO: 크기 기기 사이즈에 맞춰서 조절 되어야 함.
    private lazy var numStackView: UIStackView = {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        [firstNum, secondNum, thirdNum, fourthNum, fifthNum, sixthNum].forEach { subView in
            
            stackView.addArrangedSubview(subView)
        }
                
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

}

// MARK: - Private functions

private extension CertificationNumberViewController {
    
    func configureUI() {
        
        NSLayoutConstraint.activate([
            self.guideLabelAndPhoneNumberStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.guideLabelAndPhoneNumberStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            self.numStackView.topAnchor.constraint(equalTo: self.guideLabelAndPhoneNumberStackView.bottomAnchor, constant: 81),
            self.numStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32)
        ])
    }
}

// MARK: - View Generators

private extension CertificationNumberViewController {
    
    func numberView() -> UIStackView {
        let stackView = UIStackView()
        let numTextField = UITextField()
        let underBar = UIView()
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .center
        numTextField.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        numTextField.text = "0"
        numTextField.textAlignment = .center
        underBar.widthAnchor.constraint(equalToConstant: 52).isActive = true
        underBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underBar.backgroundColor = .black
        stackView.addArrangedSubview(numTextField)
        stackView.addArrangedSubview(underBar)
        
        return stackView
    }
}

#if DEBUG
import SwiftUI
struct CertificationNumberViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        CertificationNumberViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                CertificationNumberViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
