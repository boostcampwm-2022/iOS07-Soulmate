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
    
    func load(_ data: [Chat]) {
        guard !data.isEmpty else { return }
        
        chatDataSource.append(data)
    
        self.reloadData()                
    }
    
    func append(_ data: [Chat]) {
        
        guard !data.isEmpty else { return }
        
        chatDataSource.append(data)
        let start = chatDataSource.count
        let end = start + (data.count - 1)
        
        let indexPathes = (start..<end).map { i in
            IndexPath(item: i, section: 0)
        }
              
        self.reloadData()        
    }
    
    func scrollToBottomByOffset() {
        print(self.contentInset.bottom)
        let maxY = chatDataSource.offsets.last ?? 0
        let height = self.bounds.size.height
        let yOffset = maxY - height + self.contentInset.bottom
        
        self.setContentOffset(CGPoint(x: 0, y: yOffset > 0 ? yOffset : 0), animated: false)        
    }
    
    func scrollToBottomByItems() {
        let item = self.numberOfItems(inSection: 0) - 1        
        self.scrollToItem(at: IndexPath(item: item, section: 0), at: .bottom, animated: false)
    }
}
