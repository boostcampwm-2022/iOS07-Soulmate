//
//  IntroductionSettingViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit

final class IntroductionSettingViewController: UIViewController {
    
    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        view.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.goToNextStep()
        
        return bar
    }()
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회원님을 자유롭게\n소개해주세요."
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
    
    private lazy var introductionTextView: UITextView = {
        let textView = UITextView()
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textView.textContainerInset = .init(top: 16, left: 12, bottom: 0, right: 12)
        
        return textView
    }()
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/50"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.textColor = .labelDarkGrey
        
        return label
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
}

private extension IntroductionSettingViewController {
    
    func configureLayout() {
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        introductionTextView.snp.makeConstraints {
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.top.equalTo(self.guideLabel.snp.bottom).offset(60)
            $0.height.equalTo(120)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.introductionTextView.snp.trailing)
            $0.bottom.equalTo(self.introductionTextView.snp.top).offset(-10)
        }
    }
}

#if DEBUG
import SwiftUI
struct IntroductionSettingViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        IntroductionSettingViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                IntroductionSettingViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
