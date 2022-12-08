//
//  ChatRoomInfoCell.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import UIKit

final class ChatRoomInfoCell: UITableViewCell {
    
    static let id = String(describing: ChatRoomInfoCell.self)
    
    private lazy var chatRoomInfoView: ChatRoomInfoView = {
        let infoView = ChatRoomInfoView()
        contentView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        return infoView
    }()
    
    private lazy var separator: UIView = {
        let line = UIView()
        contentView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .labelGrey
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with info: ChatRoomInfo, uid: String) {
        chatRoomInfoView.configure(with: info, uid: uid)
    }
    
    func configure(image: UIImage) {
        chatRoomInfoView.configure(image: image)
    }
}

private extension ChatRoomInfoCell {
    func configureLayout() {
        chatRoomInfoView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(14)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-14)
        }
        
        separator.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
        }
    }
}
