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
        return UIView()
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
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(latestChatContentLabel)
        stackView.addArrangedSubview(unReadMessageCountBadge)
        
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
    
    func configure(with info: ChattingRoomInfo) {
        mateNameLabel.text = info.mateName
        latestChatTime.text = info.lastChatDate
        latestChatContentLabel.text = info.latestChatContent
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
