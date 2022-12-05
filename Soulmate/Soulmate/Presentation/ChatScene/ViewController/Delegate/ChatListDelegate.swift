//
//  ChatListDelegate.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/04.
//

import UIKit

final class ChatListDelegate: NSObject, UIScrollViewDelegate, UICollectionViewDelegate {
    
    weak var chatList: ChatListView?
    weak var chatListLayout: ChatListLayout?
    
    private var expectingEndDecelerationEvent = false
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard decelerate == false else {
            expectingEndDecelerationEvent = true
            return
        }
        
        expectingEndDecelerationEvent = false
        
        insertPrevChats()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard expectingEndDecelerationEvent else { return }
        expectingEndDecelerationEvent = false
        
        insertPrevChats()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let dataSource = chatList?.dataSource as? ChatDataSource,
              let yOffset = chatList?.contentOffset.y  else { return }
        
        if dataSource.isBufferEmpty && yOffset < 1000 {
            chatList?.loadPrevChats()
        }
    }
    
    func insertPrevChats() {
        
        let addedHeight = chatList?.insertPrevChats() ?? 0
        
        chatList?.reloadData()
        
        let currentYOffset = chatList?.contentOffset.y ?? 0
                
        
        chatList?.setContentOffset(CGPoint(x: 0, y: currentYOffset + addedHeight), animated: false)
    }
}
