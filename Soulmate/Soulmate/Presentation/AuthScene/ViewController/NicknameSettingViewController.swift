//
//  NicknameSettingViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit

final class NicknameSettingViewController: UIViewController {
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.text = "소울메이트에서 사용하실\n닉네임을 적어주세요."
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
        var font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        var descriptor = font?.fontDescriptor
        
        
        label.font = font
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필에서 표시되는 이름으로, 언제든지 변경할 수 있어요!"
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
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = .labelGrey
        
        return label
    }()
    
    private lazy var guideLabelAndDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(guideLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        return stackView
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.placeholder = "두글자 이상 입력해주세요."
        
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = GradientButton(title: "다음")
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
    }
    
    override func viewDidLayoutSubviews() {
        nicknameTextField.addUnderLine()
    }
}

private extension NicknameSettingViewController {
    
    func configureLayout() {
        guideLabelAndDescriptionStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(self.guideLabelAndDescriptionStackView.snp.bottom).offset(70)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
    }
}

#if DEBUG
import SwiftUI
struct NicknameSettingViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        NicknameSettingViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                NicknameSettingViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
