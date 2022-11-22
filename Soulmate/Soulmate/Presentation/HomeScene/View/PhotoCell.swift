//
//  PhotoCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import UIKit

import SnapKit

final class PhotoCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        contentView.addSubview(photo)
        return photo
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
        imageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(imageView.snp.height)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func loadImage(image: String) {
        // TODO: 이미지 불러오기 수정해야함
        if image.isEmpty {
            imageView.image = UIImage(systemName: "person")
        } else {
            imageView.image = UIImage(named: image)
        }
        
    }
}
