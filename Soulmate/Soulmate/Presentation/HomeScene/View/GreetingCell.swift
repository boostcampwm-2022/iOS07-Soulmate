//
//  GreetingCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import UIKit

import SnapKit

final class GreetingCell: UICollectionViewCell {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "인사말"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var greetingMessage: UILabel = {
        let message = UILabel()
        message.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        message.textColor = UIColor.labelGrey
        message.numberOfLines = 0
        message.lineBreakStrategy = .hangulWordPriority
        contentView.addSubview(message)
        return message
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(42)
            $0.height.equalTo(22)
        }
        
        greetingMessage.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(12)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalToSuperview().inset(40)
        }
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func configure(message: String) {
        greetingMessage.text = message
    }
}
