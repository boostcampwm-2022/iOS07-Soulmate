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
        
//
//        var snapshot = snapshot()
//        guard var index = snapshot.itemIdentifiers.firstIndex(
//            where: {
//                $0.id == chat.id
//            }
//        ) else { return }
//
//        var items = snapshot.itemIdentifiers
//        items[index] = chat
//
//        snapshot.deleteAllItems()
//        snapshot.appendItems(items)
//
//        apply(snapshot)
    }
    
    func update(notContaining otherId: String) {
//
//        var snapshot = snapshot()
//        var items = snapshot.itemIdentifiers
//
//        let updated = items.map { item in
//            var chat = item
//
//            if !chat.readUsers.contains(otherId) {
//                chat.readUsers.append(otherId)
//            }
//
//            return chat
//        }
//
//        snapshot.deleteAllItems()
//        snapshot.appendItems(updated)
//
//        apply(snapshot)
    }
    
    func insertBuffer() -> CGFloat {

        var snapshot = snapshot()

        guard !buffer.isEmpty else { return 0 }
                
        let beforeHeight = maxY
        var chats = buffer + snapshot.itemIdentifiers.compactMap { chatDictionary[$0] }

        appendAfterRemoveAll(chats)

        let afterHeight = maxY

        buffer = []

        return afterHeight - beforeHeight
    }
    
    func fillBuffer(with prevChats: [Chat]) {
        buffer = prevChats + buffer
    }
}
