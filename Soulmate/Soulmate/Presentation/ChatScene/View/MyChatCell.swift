//
//  MyChatCell.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import SnapKit

final class MyChatCell: UITableViewCell {
    
    static let id = String(describing: MyChatCell.self)
    
    private lazy var myChatView: MyChatView = {
        let chatView = MyChatView()
        contentView.addSubview(chatView)
        chatView.translatesAutoresizingMaskIntoConstraints = false
        
        return chatView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(from chat: Chat) {
        self.selectionStyle = .none
        myChatView.configure(with: chat)
    }
    
    func layout() {
        myChatView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
