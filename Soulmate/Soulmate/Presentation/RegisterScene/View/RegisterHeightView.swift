//
//  HeightViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/16.
//

import UIKit
import Combine

final class RegisterHeightView: UIView {
            
    // TODO: 이부분 상의하고 수정
    @Published var selectedHeight = "170"
    
    private let pickerData: [Int] = Array(140...210) // 키 범위
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님의 키를\n입력해주세요.",
            descriptionText: "신장 표시에 사용되며, 언제든 변경 가능해요"
        )
        self.addSubview(headerView)
        return headerView
    }()
    
    lazy var heightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(30, inComponent: 0, animated: true)
        self.addSubview(picker)
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    func heightPublisher() -> AnyPublisher<Int, Never> {
        return $selectedHeight.map { print($0); return Int($0)! }.eraseToAnyPublisher()
    }
}

private extension RegisterHeightView {

    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        heightPicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
}

extension RegisterHeightView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHeight = String(pickerData[row])
    }
    
}
