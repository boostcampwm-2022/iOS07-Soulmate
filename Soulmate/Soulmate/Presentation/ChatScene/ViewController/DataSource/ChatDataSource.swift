//
//  ChatDataSource.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

struct ChatDateHeader: Hashable {
    var date: String
}

final class ChatDataSource: UICollectionViewDiffableDataSource<ChatDateHeader, String> {

    let headerHeight: CGFloat = 30
    var chatDictionary: [String: Chat] = [:]
    private var buffer: [Chat] = []
    var isLoading = false
    
    var maxY: CGFloat {
        var y: CGFloat = 0
        let snapshot = snapshot()
        snapshot.sectionIdentifiers.forEach { _ in y += headerHeight }
        chatDictionary.values.forEach { y += $0.height }
        
        return y
    }
    
    var isBufferEmpty: Bool {
        return buffer.isEmpty
    }
    
    func appendAfterRemoveAll(_ data: [Chat]) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        chatDictionary.removeAll()
        
        var sections = snapshot.sectionIdentifiers
        
        for chat in data {
            
            guard let stringDate = chat.date?.yyyyMMddEEEE() else { continue }
            let chatDateHeader = ChatDateHeader(date: stringDate)
            
            if !sections.contains(chatDateHeader) {
                
                sections.append(chatDateHeader)
                snapshot.appendSections([chatDateHeader])
                snapshot.appendItems([chat.id], toSection: chatDateHeader)
                chatDictionary[chat.id] = chat
            } else {
                snapshot.appendItems([chat.id], toSection: chatDateHeader)
                chatDictionary[chat.id] = chat
            }
        }
        
        self.applySnapshotUsingReloadData(snapshot)
    }
    
    func append(_ data: [Chat]) {
        
        var snapshot = snapshot()
        var sections = snapshot.sectionIdentifiers
        
        for chat in data {
            
            guard let stringDate = chat.date?.yyyyMMddEEEE() else { continue }
            let chatDateHeader = ChatDateHeader(date: stringDate)
        
            if !sections.contains(chatDateHeader) {
                sections.append(chatDateHeader)
                snapshot.appendSections([chatDateHeader])
                snapshot.appendItems([chat.id], toSection: chatDateHeader)
                chatDictionary[chat.id] = chat
            } else {
                snapshot.appendItems([chat.id], toSection: chatDateHeader)
                chatDictionary[chat.id] = chat
            }
        }
        
        self.applySnapshotUsingReloadData(snapshot)
    }
    
    func update(_ chat: Chat) {
        
        var snapshot = snapshot()
        
        chatDictionary[chat.id] = chat
        snapshot.reconfigureItems([chat.id])
        
        apply(snapshot)
    }
    
    func update(notContaining otherId: String) {
        
        var snapshot = snapshot()
        var updateIds = chatDictionary
            .filter { !$0.value.readUsers.contains(otherId) }
            .map { $0.key }
        
        updateIds.forEach { key in
            chatDictionary[key]?.readUsers.append(otherId)
        }
        
        snapshot.reconfigureItems(updateIds)
        
        apply(snapshot)
    }
    
    func insertBuffer() -> CGFloat {

        let snapshot = snapshot()

        guard !buffer.isEmpty else { return 0 }
                
        let beforeHeight = maxY
        let chats = buffer + snapshot.itemIdentifiers.compactMap { chatDictionary[$0] }

        appendAfterRemoveAll(chats)

        let afterHeight = maxY

        buffer = []

        return afterHeight - beforeHeight
    }
    
    func fillBuffer(with prevChats: [Chat]) {
        buffer = prevChats + buffer
    }
}
