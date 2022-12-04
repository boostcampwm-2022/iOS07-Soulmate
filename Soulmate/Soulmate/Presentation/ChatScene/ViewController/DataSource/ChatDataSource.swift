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
}
