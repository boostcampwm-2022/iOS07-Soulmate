//
//  HeightViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/16.
//

import UIKit

final class HeightViewController: UIViewController {
    private let pickerData: [Int] = Array(140...210) // 키 범위
    
    // TODO: 프로그레스바 연결, 뭔가 더 좋은 방법으로?
    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        for _ in 0..<4 {
            bar.goToNextStep()
        }
        self.view.addSubview(bar)
        return bar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님의 키를\n입력해주세요."
        label.numberOfLines = 2
        label.sizeToFit()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "신장 표시에 사용되며, 언제든 변경 가능해요"
        label.sizeToFit()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = .labelGrey
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var birthPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(30, inComponent: 0, animated: true)
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

extension HeightViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
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
struct HeightViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        HeightViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                HeightViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
