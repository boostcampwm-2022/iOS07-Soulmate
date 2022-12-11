//
//  ChatListView.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatListView: UICollectionView {
    
    weak var loadPrevChatDelegate: LoadPrevChatDelegate?
    
    var chatDataSource: ChatDataSource?
    let chatListDelegate = ChatListDelegate()
    
    convenience init(hostView: UIView, fetchImage: (() async -> Data?)?) {
        self.init(frame: hostView.bounds, collectionViewLayout: ChatListLayout())
        hostView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        chatDataSource = createDateSource(fetchImage: fetchImage)
        self.dataSource = chatDataSource
        
        MyChatCell.register(with: self)
        OtherChatCell.register(with: self)
        ChatDateHeaderView.register(with: self)
        
        self.delegate = chatListDelegate
        chatListDelegate.chatList = self
        chatListDelegate.chatListLayout = self.collectionViewLayout as? ChatListLayout
    }
    
    func scrollToBottomByOffset() {
        
        guard let maxY = chatDataSource?.maxY else { return }
        let height = self.bounds.size.height
        let yOffset = maxY - height + self.contentInset.bottom
        
        self.setContentOffset(CGPoint(x: 0, y: yOffset > 0 ? yOffset : 0), animated: false)        
    }
}

// MARK: - DataSource control
extension ChatListView {

    func append(_ data: [Chat]) {
        
        guard !data.isEmpty else { return }
        chatDataSource?.append(data)
    }
    
    func update(_ chat: Chat) {
        chatDataSource?.update(chat)
    }
    
    func update(notContaining othersId: String) {
        chatDataSource?.update(notContaining: othersId)
    }
    
    func insertPrevChats() -> CGFloat {
        
        return chatDataSource?.insertBuffer() ?? 0
    }
    
    func loadPrevChats() {
        loadPrevChatDelegate?.loadPrevChats()
    }
    
    func fillBuffer(with chats: [Chat]) {
        chatDataSource?.fillBuffer(with: chats)
        chatDataSource?.isLoading = false
    }
}

// MARK: - Cell, SuppleView Provider
private extension ChatListView {
    func createDateSource(fetchImage: (() async -> Data?)?) -> ChatDataSource {
        
        let dataSource = ChatDataSource(
            collectionView: self) { [weak self] collectionView, indexPath, id in
                
                guard let chat = self?.chatDataSource?.chatDictionary[id] else { return nil }
                
                if chat.isMe {
                    return MyChatCell.dequeue(from: collectionView, at: indexPath, with: chat)
                } else {
                    let otherChatCell = OtherChatCell.dequeu(from: collectionView, at: indexPath, with: chat)
                    
                    Task {
                        guard let imageData = await fetchImage?(),
                              let image = UIImage(data: imageData) else { return }
                        
                        await MainActor.run {
                            if collectionView.cellForItem(at: indexPath) != nil {
                                otherChatCell.set(image: image)
                            }
                        }
                    }
                    
                    
                    return otherChatCell
                }
            }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            
            guard let chatDateHeader = self?.chatDataSource?.sectionIdentifier(
                for: indexPath.section) as? ChatDateHeader else { return nil }
            
            let stringDate = chatDateHeader.date
            
            return ChatDateHeaderView.dequeu(
                from: collectionView,
                at: indexPath,
                date: stringDate
            )
        }
        
        return dataSource
    }
}
