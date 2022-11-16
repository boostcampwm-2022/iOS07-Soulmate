//
//  BirthViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/16.
//

import UIKit

class BirthViewController: UIViewController {

    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        for _ in 0..<3 {
            bar.goToNextStep()
        }
        self.view.addSubview(bar)
        return bar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님의 생일은\n언제인가요?"
        label.numberOfLines = 2
        label.sizeToFit()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "나이 표시에 사용되며, 언제든 변경 가능해요"
        label.sizeToFit()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = .labelGrey
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var birthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        self.view.addSubview(picker)
        return picker
    }()
    
    
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

private extension BirthViewController {
    func configureLayout() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        birthPicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.snp.bottom).inset(46)
            $0.height.equalTo(54)
        }
        
    }
}


#if DEBUG
import SwiftUI
struct BirthViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        BirthViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                BirthViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
