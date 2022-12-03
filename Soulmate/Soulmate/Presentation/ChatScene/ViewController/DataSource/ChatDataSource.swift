//
//  ChatDataSource.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatDataSource: NSObject, UICollectionViewDataSource {
    
    private var chats: [Chat] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chat = chats[indexPath.item]
        
        if chat.isMe {
            return MyChatCell.dequeue(from: collectionView, at: indexPath)
        } else {
            return OtherChatCell.dequeu(from: collectionView, at: indexPath)
        }
    }
}
