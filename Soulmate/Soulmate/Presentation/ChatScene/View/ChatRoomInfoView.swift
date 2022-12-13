//
//  ChatRoomInfoView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import UIKit

final class ChatRoomInfoView: UIView {
    
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
    
    lazy var latestChatTime: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textColor = .labelGrey
        
        return label
    }()
    
    private lazy var latestChatContentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = .labelDarkGrey
        
        return label
    }()
    
    private lazy var unReadMessageCountBadge: UIView = {

        let container = UIView()
        container.widthAnchor.constraint(equalToConstant: 22).isActive = true
        container.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        
        container.addSubview(unReadMessageCounterLabel)
        unReadMessageCounterLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        unReadMessageCounterLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        return container
    }()
    
    private lazy var unReadMessageCounterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "2"
        label.layer.cornerRadius = 9
        label.backgroundColor = .mainPurple
        label.clipsToBounds = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        return label
    }()
    
    private lazy var nameTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(mateNameLabel)
        stackView.addArrangedSubview(latestChatTime)
        
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(latestChatContentLabel)
        stackView.addArrangedSubview(unReadMessageCountBadge)
        stackView.spacing = 5
        
        return stackView
    }()
    
    private lazy var nameTimeContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(nameTimeStackView)
        stackView.addArrangedSubview(contentStackView)
        
        return stackView
    }()
    
    private lazy var superStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.addArrangedSubview(mateProfileImageView)
        stackView.addArrangedSubview(nameTimeContentStackView)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with info: ChatRoomInfo, uid: String) {
        guard let unread = info.unreadCount[uid] else { return }
        
        if unread != 0 {
            unReadMessageCountBadge.isHidden = false
            unReadMessageCounterLabel.text = String(Int(unread))
        } else {
            unReadMessageCountBadge.isHidden = true
            unReadMessageCounterLabel.text = nil
        }
                
        guard let mateId = info.userIds.first(where: { $0 != uid }) else { return }
        
        mateNameLabel.text = info.userNames[mateId]
        latestChatTime.text = info.lastChatDate?.passedTime()
        latestChatContentLabel.text = info.latestChatContent
    }
    
    func configure(image: UIImage) {
        mateProfileImageView.image = image
    }
    
    func resetImage() {
        mateProfileImageView.image = nil
    }
}

private extension ChatRoomInfoView {
    func configureLayout() {
        superStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.bottom.equalTo(self.snp.bottom)
            $0.trailing.equalTo(self.snp.trailing)
        }
    }
}
