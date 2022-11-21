//
//  IntroductionSettingViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit
import SnapKit
import Combine

final class RegisterIntroductionView: UIView {
        
    var bag = Set<AnyCancellable>()
    
    var textSubject = PassthroughSubject<String?, Never>()
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님을 자유롭게\n소개해주세요."
        )
        self.addSubview(headerView)
        return headerView
    }()
    
    lazy var introductionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textView.textContainerInset = .init(top: 16, left: 12, bottom: 0, right: 12)
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        textView.showsVerticalScrollIndicator = false
        textView.textStorage.delegate = self
        return textView
    }()
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/50"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.textColor = .labelDarkGrey
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var introductionStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.addArrangedSubview(textCountLabel)
        stackView.addArrangedSubview(introductionTextView)
        
        return stackView
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
}

extension RegisterIntroductionView: NSTextStorageDelegate {
    func textStorage(
        _ textStorage: NSTextStorage,
        didProcessEditing editedMask: NSTextStorage.EditActions,
        range editedRange: NSRange,
        changeInLength delta: Int) {
            textSubject.send(textStorage.string)
    }
}

private extension RegisterIntroductionView {
    
    func bind() {
        textSubject
            .compactMap { $0 }
            .sink { [weak self] value in
                self?.textCountLabel.text = "\(value.count)/50"
            }
            .store(in: &bag)
    }

    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {

        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        introductionStackView.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.top.equalTo(self.registerHeaderStackView.snp.bottom).offset(60)
        }
    }
}
