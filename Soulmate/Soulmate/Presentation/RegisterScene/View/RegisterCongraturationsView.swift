//
//  CongraturationsViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit

final class RegisterCongraturationsView: UIView {
            
    private lazy var confetti: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Confetti")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 100
        
        return imageView
    }()
    
    private lazy var profileBorder: UIView = {
        let circle = UIView()
        self.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.widthAnchor.constraint(equalToConstant: 216).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 216).isActive = true
        circle.layer.cornerRadius = 108
        circle.layer.borderColor = UIColor.mainPurple?.cgColor
        circle.layer.borderWidth = 4
        
        return circle
    }()
    
    private lazy var conguraturationsLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Conguraturations!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = .labelGrey
        label.numberOfLines = 2
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.33
        paragraphStyle.alignment = .center
                
        label.attributedText = NSMutableAttributedString(
            string: "회원가입이 완료되었어요.\n이제 소울메이트를 찾으러 가볼까요?",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RegisterCongraturationsView {

    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        
        confetti.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(100)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        profileImage.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY).offset(-100)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        profileBorder.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY).offset(-100)
            $0.centerX.equalTo(self.profileImage.snp.centerX)
        }
        
        conguraturationsLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileBorder.snp.bottom).offset(40)
            $0.centerX.equalTo(self.profileImage.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.conguraturationsLabel.snp.bottom).offset(16)
            $0.centerX.equalTo(self.profileImage.snp.centerX)
        }
    }
}
