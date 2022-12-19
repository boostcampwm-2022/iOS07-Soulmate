//
//  SelectableCell.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/11.
//

import UIKit
import SnapKit

class SelectableCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.layer.borderColor = UIColor.borderPurple?.cgColor
                self.contentView.backgroundColor = UIColor.lightPurple
                self.checkImageView.image = UIImage(named: "checkOn")
            } else {
                self.contentView.layer.borderColor = UIColor.symbolGrey?.cgColor
                self.contentView.backgroundColor = UIColor.white
                self.checkImageView.image = UIImage(named: "checkOff")
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
        self.isSelected = false
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
    }
    
    func fill(with title: String) {
        self.titleLabel.text = title
    }
    
    func hideCheckView() {
        self.checkImageView.isHidden = true
    }
    
}
