//
//  OtherChatView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import SnapKit

final class OtherChatView: UIView {
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 18
        
        return imageView
    }()
    
    private lazy var chatLabel: UILabel = {
        let label = PaddingLabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .backgroundGrey
        label.layer.cornerCurve = .continuous
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textColor = .black
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        label.textColor = .labelGrey
        label.text = "오전 8:18"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with chat: Chat) {
        chatLabel.text = chat.text
    }
    
    func layout() {
        
        chatLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(5)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
            $0.width.lessThanOrEqualTo(230)
        }
        
        profileImage.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(36)
            $0.top.equalTo(chatLabel.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(chatLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
}
