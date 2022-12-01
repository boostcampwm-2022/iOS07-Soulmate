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
        imageView.clipsToBounds = true
        
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
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        label.textColor = .labelGrey
        
        return label
    }()
    
    private lazy var readCount: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 11)
        label.textColor = .messagePurple
        
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
        timeLabel.text = chat.date?.aHmm() ?? "..."
        if let count = unreadCount(of: chat) {
            readCount.text = "\(count)"
        }
    }
    
    func set(image: UIImage?) {
        self.profileImage.image = image
    }
    
    private func layout() {
        
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
        
        readCount.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
    
    private func unreadCount(of chat: Chat) -> Int? {
        guard 0..<2 ~= chat.readUsers.count else { return nil }
        return 2 - chat.readUsers.count
    }
}
