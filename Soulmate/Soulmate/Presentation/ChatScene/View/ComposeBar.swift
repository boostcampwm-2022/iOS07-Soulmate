//
//  ComposeBar.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import UIKit

final class ComposeBar: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var messageInput: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func configure(with delegate: NSTextStorageDelegate) {
        Bundle.main.loadNibNamed("ComposeBar", owner: self)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        messageInput.textStorage.delegate = delegate
        sendButton.isEnabled = false
    }
    
    func activateSendButton() {
        sendButton.isEnabled = true
        sendButton.setImage(UIImage(named: "messageOn"), for: .normal)
    }
    
    func deactivateSendButton() {
        sendButton.isEnabled = false
        sendButton.setImage(UIImage(named: "messageOff"), for: .normal)
    }
    
    func sendButtonPublisher() -> AnyPublisher<Void, Never> {
        return sendButton.tapPublisher()
    }
}
