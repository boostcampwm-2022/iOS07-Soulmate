//
//  NicknameSettingViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit
import Combine

final class RegisterNickNameView: UIView {
            
    var bag = Set<AnyCancellable>()
        
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "소울메이트에서 사용하실\n닉네임을 적어주세요.",
            descriptionText: "프로필에서 표시되는 이름으로, 언제든지 변경할 수 있어요!"
        )
        self.addSubview(headerView)
        return headerView
    }()
    
    lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textField.placeholder = "두글자 이상 입력해주세요."
        
        return textField
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
        bind()
    }
    
//    override func viewDidLayoutSubviews() {
//        nicknameTextField.addUnderLine()
//    }
}


private extension RegisterNickNameView {
    
    func bind() {
    }

    func configureView() {
        self.backgroundColor = .systemBackground
        nicknameTextField.addUnderLine()
    }
    
    func configureLayout() {

        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(registerHeaderStackView.snp.bottom).offset(70)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
    }
}

