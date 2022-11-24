//
//  BasicInfoCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import UIKit

import SnapKit

final class BasicInfoCell: UICollectionViewCell {
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var drinkLabel: UILabel = {
        let label = UILabel()
        label.text = "음주"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var smokeLabel: UILabel = {
        let label = UILabel()
        label.text = "흡연"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var heightInput: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var mbtiInput: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var drinkInput: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var smokeInput: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
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
        heightLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(33)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(heightLabel.snp.bottom).offset(22)
        }
        
        drinkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(mbtiLabel.snp.bottom).offset(22)
        }
        
        smokeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(drinkLabel.snp.bottom).offset(22)
        }
        
        heightInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalToSuperview().offset(32)
        }
        
        mbtiInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(heightInput.snp.bottom).offset(20)
        }
        
        drinkInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(mbtiInput.snp.bottom).offset(20)
        }
        
        smokeInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(drinkInput.snp.bottom).offset(20)
        }
    }
    
    func configure(height: Int, mbti: String, drink: String, smoke: String) {
        heightInput.text = String(height)
        mbtiInput.text = mbti
        drinkInput.text = drink
        smokeInput.text = smoke
    }
}
