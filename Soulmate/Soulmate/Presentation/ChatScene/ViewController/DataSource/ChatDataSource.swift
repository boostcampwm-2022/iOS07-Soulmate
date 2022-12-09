//
//  ChatDataSource.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatDataSource: NSObject, UICollectionViewDataSource {

    struct ChatDateHeader {
        var date: String
        var height: CGFloat
    }
    
    private(set) var headers: [ChatDateHeader] = []
    private(set) var chats: [[Chat]] = []
    private var dateIndex: [String: Int] = [:]
    private var chatIndex: [String: (section: Int, item: Int)] = [:]
    private var buffer: [Chat] = []
    var isLoading = false
    
    var maxY: CGFloat {
        var y: CGFloat = 0
        headers.forEach { y += $0.height }
        chats.forEach { $0.forEach { y += $0.height } }
        
        return y
    }

    var isBufferEmpty: Bool {
        return buffer.isEmpty
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chat = chats[indexPath.section][indexPath.row]
        
        if chat.isMe {
            return MyChatCell.dequeue(from: collectionView, at: indexPath, with: chat)
        } else {
            return OtherChatCell.dequeu(from: collectionView, at: indexPath, with: chat)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = headers[indexPath.section]
        
        return ChatDateHeaderView.dequeu(from: collectionView, at: indexPath, date: header.date)
    }
}

extension ChatDataSource {
    
    func append(_ data: [Chat]) {
        for chat in data {
            
            guard let stringDate = chat.date?.yyyyMMddEEEE() else { continue }
            
            if dateIndex[stringDate] == nil {
                chats.append([chat])
                headers.append(ChatDateHeader(date: stringDate, height: 30))
                dateIndex[stringDate] = chats.count - 1
                chatIndex[chat.id] = (chats.count - 1, 0)
            } else if let index = dateIndex[stringDate] {
                chats[index].append(chat)
                chatIndex[chat.id] = (chats.count - 1, chats[index].count - 1)
            }
        }
    }
    
    func update(_ chat: Chat) {

        guard let index = chatIndex[chat.id] else { return }
        
        chats[index.section][index.item] = chat
    }
    
    func update(notContaining otherId: String) {

        for section in (0..<chats.count).reversed() {
            for item in (0..<chats[section].count).reversed() {
                if chats[section][item].readUsers.contains(otherId) { break }
                chats[section][item].readUsers.append(otherId)
            }
        }
    }
    
    func insertBuffer() -> CGFloat {
        guard !buffer.isEmpty else { return 0 }
        
        let beforeHeight = maxY
        
        let oldChats = chats.flatMap { $0 }
        let newChats = buffer + oldChats
        
        headers.removeAll()
        chats.removeAll()
        dateIndex.removeAll()
        chatIndex.removeAll()
        
        append(newChats)
        
        let afterHeight = maxY
        
        buffer = []
        
        return afterHeight - beforeHeight
    }
    
    func fillBuffer(with prevChats: [Chat]) {
        buffer = prevChats + buffer
    }
}
