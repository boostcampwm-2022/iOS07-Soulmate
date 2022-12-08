//
//  ChatListView.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatListView: UICollectionView {
    
    weak var loadPrevChatDelegate: LoadPrevChatDelegate?
    
    let chatDataSource = ChatDataSource()
    let chatListDelegate = ChatListDelegate()
    
    convenience init(hostView: UIView) {
        self.init(frame: hostView.bounds, collectionViewLayout: ChatListLayout())
        hostView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = chatDataSource
        MyChatCell.register(with: self)
        OtherChatCell.register(with: self)
        
        self.delegate = chatListDelegate
        chatListDelegate.chatList = self
        chatListDelegate.chatListLayout = self.collectionViewLayout as? ChatListLayout
    }
    
    func load(_ data: [Chat]) {
        guard !data.isEmpty else { return }
        
        chatDataSource.append(data)
    
        self.reloadData()                
    }
    
    func append(_ data: [Chat]) {
        
        guard !data.isEmpty else { return }
        chatDataSource.append(data)
              
        self.reloadData()
    }
    
    func update(_ chat: Chat) {
        chatDataSource.update(chat)
        
        self.reloadData()
    }
    
    func update(notContaining othersId: String) {
        chatDataSource.update(notContaining: othersId)
        
        self.reloadData()
    }
    
    func insertPrevChats() -> CGFloat {        
        
        return chatDataSource.insertBuffer()
    }
    
    func loadPrevChats() {
        loadPrevChatDelegate?.loadPrevChats()
    }
    
    func fillBuffer(with chats: [Chat]) {
        chatDataSource.fillBuffer(with: chats)
        chatDataSource.isLoading = false
    }
    
    func scrollToBottomByOffset() {
        
        let maxY = chatDataSource.offsets.last ?? 0
        let height = self.bounds.size.height
        let yOffset = maxY - height + self.contentInset.bottom
        
        self.setContentOffset(CGPoint(x: 0, y: yOffset > 0 ? yOffset : 0), animated: false)        
    }
}
