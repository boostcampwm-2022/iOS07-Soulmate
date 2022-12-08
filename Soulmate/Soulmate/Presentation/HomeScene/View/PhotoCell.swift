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
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        contentView.addSubview(photo)
        return photo
    }()
    
    private lazy var loadingIndicator: LoadingIndicator = {
        let loading = LoadingIndicator()
        imageView.addSubview(loading)
        return loading
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        loadingIndicator.startAnimating()
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
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func fill(image: UIImage) {
        imageView.image = image.resize(newWidth: self.contentView.frame.width)
        loadingIndicator.stopAnimating()
    }
}
