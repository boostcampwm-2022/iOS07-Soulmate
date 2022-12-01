//
//  ModificationTitleSupplementaryView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import UIKit

class ModificationTitleSupplementaryView: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        return label
    }()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
