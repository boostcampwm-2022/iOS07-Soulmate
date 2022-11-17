//
//  AddPhotoCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/17.
//

import UIKit

import SnapKit

final class AddPhotoCell: UICollectionViewCell {
    private lazy var addPhotoView: UIView = {
        let view = UIView()
        addSubview(view)
        return view
    }()
    
    lazy var addPhotoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        imageView.image = UIImage(named: "plusColor")
        addPhotoView.addSubview(imageView)
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.layer.borderColor = UIColor.borderPurple?.cgColor
                self.contentView.backgroundColor = UIColor.lightPurple
                self.addPhotoImageView.image = UIImage(named: "plusColor")
            } else {
                self.contentView.layer.borderColor = UIColor.backgroundGrey?.cgColor
                self.contentView.backgroundColor = UIColor.backgroundGrey
                self.addPhotoImageView.image = UIImage(named: "plusGrey")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 14
        self.isSelected = true
    }
    
    func configureLayout() {
        addPhotoView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        addPhotoImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
