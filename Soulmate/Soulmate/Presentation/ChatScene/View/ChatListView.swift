//
//  ChatListView.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatListView: UICollectionView {
    
    let chatDataSource = ChatDataSource()
    
    convenience init(hostView: UIView) {
        self.init(frame: hostView.bounds, collectionViewLayout: ChatListLayout())
        hostView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = chatDataSource
        MyChatCell.register(with: self)
        OtherChatCell.register(with: self)
    }
}
