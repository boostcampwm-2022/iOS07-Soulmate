//
//  OtherChatCell.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import SnapKit

final class OtherChatCell: UICollectionViewCell {
    
    static let id = String(describing: OtherChatCell.self)
    static func register(with collectionView: UICollectionView) {
        collectionView.register(OtherChatCell.self, forCellWithReuseIdentifier: id)
    }
    static func dequeu(from collectionView: UICollectionView, at indexPath: IndexPath, with chat: Chat) -> OtherChatCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: id,
            for: indexPath) as? OtherChatCell ?? OtherChatCell()
        
        cell.configure(from: chat)
        
        return cell
    }
    
    private lazy var otherChatView: OtherChatView = {
        let chatView = OtherChatView()
        contentView.addSubview(chatView)
        chatView.translatesAutoresizingMaskIntoConstraints = false
        
        return chatView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        otherChatView.set(image: nil)
    }
    
    func configure(from chat: Chat) {
        otherChatView.configure(with: chat)
    }
    
    func set(image: UIImage) {
        otherChatView.set(image: image)
    }
    
    private func layout() {
        otherChatView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
