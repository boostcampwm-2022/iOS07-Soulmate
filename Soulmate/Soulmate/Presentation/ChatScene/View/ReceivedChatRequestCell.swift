//
//  ReceivedChatRequestCell.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import UIKit

final class ReceivedChatRequestCell: UITableViewCell {
    
    static let id = String(describing: ReceivedChatRequestCell.self)
    
    private lazy var receivedChatRequestView: ReceivedChatRequestView = {
        let requestView = ReceivedChatRequestView()
        contentView.addSubview(requestView)
        requestView.translatesAutoresizingMaskIntoConstraints = false
        
        return requestView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ReceivedChatRequestCell {
    func configureLayout() {
        receivedChatRequestView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(14)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-14)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
}
