//
//  MyPageView.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/24.
//

import Foundation
import UIKit
import SnapKit
import Combine

final class MyPageView: UIView {
    
    var cancellables = Set<AnyCancellable>()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        self.addSubview(view)
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 78
        imageView.layer.borderWidth = 6
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.backgroundColor = UIColor.white.cgColor
        imageView.backgroundColor = .white
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23, weight: .heavy))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 23
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.symbolGrey?.cgColor
        self.addSubview(button)
        return button
    }()
    
    lazy var profileNameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    lazy var profileAgeLabel: UILabel = {
        let ageLabel = UILabel()
        ageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        ageLabel.sizeToFit()
        
        return ageLabel
    }()
    
    lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6

        [profileNameLabel, profileAgeLabel].forEach { stackView.addArrangedSubview($0) }
        self.addSubview(stackView)
        return stackView
    }()
    
    lazy var remainingHeartButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")?.resized(to: CGSize(width: 15, height: 15)).withTintColor(.borderPurple ?? .purple)
        config.imagePlacement = .trailing
        config.titleAlignment = .automatic
        config.imagePadding = UIScreen.main.bounds.width - 160
        config.baseForegroundColor = .black
        config.title = "보유 하트"
        
        let button = UIButton(configuration: config)
        button.backgroundColor = .lightPurple
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        
        self.addSubview(button)
        return button
    }()
    
    lazy var remainingHeartLabel: UILabel = {
        let label = UILabel()
        label.text = "0개"
        label.textColor = .mainPurple
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        label.isUserInteractionEnabled = false
        self.addSubview(label)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MyPageMenuCollectionViewCell.self, forCellWithReuseIdentifier: MyPageMenuCollectionViewCell.identifier)
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        self.backgroundColor = .myPageGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(174)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(contentView.snp.top)
            $0.width.height.equalTo(156)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.width.height.equalTo(46)
        }
        
        profileInfoStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        remainingHeartButton.snp.makeConstraints {
            $0.top.equalTo(profileInfoStackView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(62)
        }
        
        remainingHeartLabel.snp.makeConstraints {
            $0.centerY.equalTo(remainingHeartButton.snp.centerY)
            $0.trailing.equalTo(remainingHeartButton.snp.trailing).inset(40)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(remainingHeartButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
