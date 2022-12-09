//
//  ChatDateHeaderView.swift.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/09.
//

import UIKit
import SnapKit

final class ChatDateHeaderView: UICollectionReusableView {
    
    static let id = String(describing: ChatDateHeaderView.self)
    
    static func register(with collectionView: UICollectionView) {
        collectionView.register(
            ChatDateHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: id
        )
    }
    
    static func dequeu(from collectionView: UICollectionView, at indexPath: IndexPath, date: String) -> ChatDateHeaderView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: id,
            for: indexPath
        ) as? ChatDateHeaderView ?? ChatDateHeaderView()
        
        header.configure(with: date)
        
        return header
    }
    
    private lazy var capsuleView: UIView = {
        let capsule = UIView()
        self.addSubview(capsule)
        capsule.translatesAutoresizingMaskIntoConstraints = false
        capsule.backgroundColor = .secondarySystemBackground
        capsule.layer.cornerCurve = .continuous
        capsule.layer.cornerRadius = 13
        
        return capsule
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        capsuleView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .labelDarkGrey
        label.text = "1111년 11월 11일 일요일"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: String) {
        dateLabel.text = date
    }
    
    private func layout() {

        capsuleView.snp.makeConstraints {
            $0.height.equalTo(26)
            $0.width.equalTo(180)
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
}
