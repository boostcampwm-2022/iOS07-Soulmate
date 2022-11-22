//
//  AddPhotoCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/17.
//

import UIKit

import SnapKit

final class AddPhotoCell: UICollectionViewCell {

    lazy var addPhotoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.backgroundGrey?.cgColor
        imageView.backgroundColor = UIColor.backgroundGrey
        self.contentView.addSubview(imageView)
        return imageView
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
        configureView()
    }
    
    func configureView() {
        addPhotoImageView.contentMode = .center
        addPhotoImageView.image = UIImage(named: "plusGrey")
    }
    
    func configureLayout() {
        addPhotoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func fill(with photoData: Data?) {
        if let data = photoData,
           let image = UIImage(data: data) {
            addPhotoImageView.contentMode = .scaleAspectFill
            addPhotoImageView.image = image
        }
    }
}
