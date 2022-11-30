//
//  MyChatView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import SnapKit

final class MyChatView: UIView {
    
    private lazy var chatLabel: UILabel = {
        let label = PaddingLabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .messagePurple
        label.layer.cornerCurve = .continuous
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        
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
        timeLabel.text = chat.state == .sending ? "..." : chat.date?.aHmm()
        if let count = unreadCount(of: chat) {
            readCount.text = "\(count)"
        }
    }
    
    private func layout() {
        
        chatLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(5)
            $0.trailing.equalTo(self.snp.trailing).offset(-16)
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
            $0.width.lessThanOrEqualTo(230)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(chatLabel.snp.leading).offset(-5)
            $0.bottom.equalTo(chatLabel.snp.bottom)
        }
        
        readCount.snp.makeConstraints {
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-5)
            $0.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
    
    private func unreadCount(of chat: Chat) -> Int? {
        guard 0..<2 ~= chat.readUsers.count else { return nil }
        return 2 - chat.readUsers.count
    }
}
