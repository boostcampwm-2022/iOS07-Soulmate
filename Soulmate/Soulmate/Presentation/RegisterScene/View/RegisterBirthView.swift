//
//  BirthViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/16.
//

import UIKit
import Combine

final class RegisterBirthView: UIView {
    
    var bag = Set<AnyCancellable>()
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님의 생일은\n언제인가요?",
            descriptionText: "나이 표시에 사용되며, 언제든 변경 가능해요"
        )
        self.addSubview(headerView)
        return headerView
    }()
    
    lazy var birthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
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
    
    func birthPublisher() -> AnyPublisher<Date, Never> {
        return birthPicker.datePublisher()
    }
}

private extension RegisterBirthView {

    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        birthPicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
