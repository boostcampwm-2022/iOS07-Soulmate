//
//  RecommendView.swift
//  Soulmate
//
//  Created by termblur on 2022/12/02.
//

import UIKit

import SnapKit

final class RecommendView: UICollectionViewCell {
    
    private lazy var recommendAgainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.text = "한번 더 추천받기"
        label.textAlignment = .center
        label.textColor = UIColor.messagePurple
        label.layer.cornerRadius = 10
        label.backgroundColor = .white
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.borderPurple?.cgColor
        addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        recommendAgainLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
    }

}
