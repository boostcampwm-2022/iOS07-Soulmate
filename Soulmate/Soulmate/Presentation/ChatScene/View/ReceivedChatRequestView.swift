//
//  ReceivedChatRequestView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import UIKit

final class ReceivedChatRequestView: UIView {
    
    private var acceptAction: (() -> ())?
    private var denyAction: (() -> ())?
    
    private lazy var mateProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 31
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 62).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 62).isActive = true
        
        return imageView
    }()
    
    private lazy var mateNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        
        return label
    }()
    
    private lazy var chatContentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = .labelDarkGrey
        label.text = "대화요청이 왔습니다!"
        
        return label
    }()
    
    private lazy var nameContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(mateNameLabel)
        stackView.addArrangedSubview(chatContentLabel)
        
        return stackView
    }()
    
    private lazy var superStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.addArrangedSubview(mateProfileImageView)
        stackView.addArrangedSubview(nameContentStackView)
        
        return stackView
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "friendAccept"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.addAction(
            UIAction { _ in self.acceptAction?() },
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var denyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "friendDelete"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.addAction(
            UIAction { _ in self.denyAction?() },
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(denyButton)
        stackView.addArrangedSubview(acceptButton)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with request: ReceivedMateRequest) {
        mateNameLabel.text = request.mateName
    }
    
    func configure(image: UIImage) {
        mateProfileImageView.image = image
    }
    
    func configureAccept(action: (() -> ())?) {
        acceptAction = action
    }
    
    func configureDeny(action: (() -> ())?) {
        denyAction = action
    }
}

private extension ReceivedChatRequestView {
    func configureLayout() {
        
        superStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.bottom.equalTo(self.snp.bottom)
            $0.trailing.equalTo(buttonStackView.snp.leading).offset(-10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerY.equalTo(superStackView.snp.centerY)
            $0.trailing.equalTo(self.snp.trailing)
        }
    }
}
