//
//  CandidatesCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/14.
//

import UIKit

import SnapKit

final class CandidatesCell: UICollectionViewCell {
    private lazy var candidateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.cornerRadius = 10
        addSubview(view)
        return view
    }()
    
    private lazy var candidateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFit
        candidateView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var candidateSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.labelDarkGrey
        view.layer.cornerRadius = 10
        candidateView.addSubview(view)
        return view
    }()
    
    private lazy var candidateName: UILabel = {
        let label = UILabel()
        label.text = "초록잎"
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        candidateSubView.addSubview(label)
        return label
    }()
    
    private lazy var candidateAge: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        candidateSubView.addSubview(label)
        return label
    }()
    
    private lazy var candidateMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapGrey")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        candidateSubView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var candidateDistance: UILabel = {
        let label = UILabel()
        label.text = "3 km"
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        candidateSubView.addSubview(label)
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        candidateImageView.image = UIImage(named: "photo")
        candidateName.text = ""
        candidateAge.text = ""
        candidateDistance.text = ""
    }
    
}

private extension CandidatesCell {
    func configureLayout() {
        candidateName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        candidateAge.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(84)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        candidateMapImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
            $0.left.equalToSuperview().inset(22.48)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        candidateDistance.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        candidateSubView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        candidateImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
        candidateView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(candidateView.snp.width)
        }
    }
}
