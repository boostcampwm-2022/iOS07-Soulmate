//
//  MyChatCell.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import SnapKit

final class MyChatCell: UICollectionViewCell {
    
    static let id = String(describing: MyChatCell.self)
    static func register(with collectionView: UICollectionView) {
        collectionView.register(MyChatCell.self, forCellWithReuseIdentifier: id)
    }
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> MyChatCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: id,
            for: indexPath) as? MyChatCell ?? MyChatCell()
        
        return cell
    }
    
    private lazy var myChatView: MyChatView = {
        let chatView = MyChatView()
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
    }
    
    func configure(from chat: Chat) {
        myChatView.configure(with: chat)
    }
    
    func layout() {
        myChatView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
