//
//  KeyboardMonitor.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/25.
//

import Combine
import UIKit

final class KeyboardMonitor: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0
    
    init() {
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillShowNotification)
        .compactMap { (notification: Notification) -> CGRect in
            return notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        }
        .map { (keyboardFrame: CGRect) -> CGFloat in
            return keyboardFrame.height
        }
        .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
        
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillHideNotification)
        .compactMap { (notification: Notification) -> CGFloat in
            return  .zero
        }
        .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
    }
}
