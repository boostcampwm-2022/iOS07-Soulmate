//
//  HomeView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    
    // MARK: UI Components
    
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var numOfHeartButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.labelDarkGrey, for: .normal)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.contentHorizontalAlignment = .right
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        self.addSubview(button)

        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.bounces = true
        collection.delaysContentTouches = false
        collection.isPagingEnabled = false
        collection.backgroundColor = .clear
        self.addSubview(collection)
        return collection
    }()
    
    lazy var hiddenLabel: UILabel = {
        let label = UILabel()
        label.text = "가까운 거리에 추천 상대가 없어요."
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.textColor = .gray
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.backgroundColor = .white
        label.isHidden = true
        self.addSubview(label)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(64)
            $0.width.equalTo(140)
        }

        numOfHeartButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(logo.snp.centerY)
            $0.height.equalTo(28)
            $0.width.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
        hiddenLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
}

// MARK: Compositional Layout

private extension HomeView {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.mainSectionLayout()
            default: fatalError()
            }
        }
    }
    
    func mainSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(94))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: RecommendFooterView.footerKind,
            alignment: .bottom
        )
        footer.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.boundarySupplementaryItems = [footer]

        return section
    }
}
