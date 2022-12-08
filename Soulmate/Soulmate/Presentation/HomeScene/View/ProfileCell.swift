//
//  ProfileCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import UIKit
import CoreLocation
import SnapKit

final class ProfileCell: UICollectionViewCell {
    private lazy var partnerSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        contentView.addSubview(view)
        return view
    }()

    private lazy var partnerName: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        partnerSubView.addSubview(label)
        return label
    }()
    
    private lazy var partnerAge: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        partnerSubView.addSubview(label)
        return label
    }()
    
    private lazy var partnerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapColor")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        partnerSubView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var partnerDistance: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.labelGrey
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        partnerSubView.addSubview(label)
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
        
        partnerName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerAge.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalTo(partnerName.snp.trailing).offset(6)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerMapImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
            $0.leading.equalToSuperview().inset(22.48)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        partnerDistance.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.leading.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        partnerSubView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func fill(previewViewModel: DetailPreviewViewModel) {
        partnerName.text = previewViewModel.name
        partnerDistance.text = previewViewModel.distance
        partnerAge.text = previewViewModel.age
    }
}
