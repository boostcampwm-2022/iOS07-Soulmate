//
//  ChatDataSource.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatDataSource: NSObject, UICollectionViewDataSource {
    
    private var chats: [Chat] = []
    private(set) var offsets: [CGFloat] = []
    private var buffer: [Chat] = []
    var isLoading = false
    
    var heights: [CGFloat] {
        return chats.map { $0.height }
    }
    
    var ids: [String] {
        return chats.map { $0.id }
    }
    
    var count: Int {
        return chats.count
    }
    
    var endIndex: Int {
        return chats.endIndex
    }
    
    var isBufferEmpty: Bool {
        return buffer.isEmpty
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chat = chats[indexPath.item]
        
        if chat.isMe {
            return MyChatCell.dequeue(from: collectionView, at: indexPath, with: chat)
        } else {
            return OtherChatCell.dequeu(from: collectionView, at: indexPath, with: chat)
        }
    }
}

extension ChatDataSource {
    
    func append(_ data: [Chat]) {
        chats += data
        for chat in data {
            offsets.append((offsets.last ?? 0) + chat.height)
        }
    }
    
    func update(_ chat: Chat) {
        guard let index = chats.firstIndex(
            where: { old in
                old.id == chat.id
            })else { return }
        
        chats[index] = chat
    }
    
    func insertBuffer() -> CGFloat {
        guard !buffer.isEmpty else { return 0 }
        
        chats = buffer + chats
        offsets.removeAll()
        
        for chat in chats {
            offsets.append((offsets.last ?? 0) + chat.height)
        }
        
        let addedHeight = buffer.reduce(0) { partialResult, chat in
            return partialResult + chat.height
        }
        
        buffer = []
        
        return addedHeight
    }
    
    func fillBuffer(with prevChats: [Chat]) {
        buffer = prevChats + buffer
    }
}
