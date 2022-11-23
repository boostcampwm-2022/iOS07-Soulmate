//
//  CandidatesCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/14.
//

import UIKit

import SnapKit

final class PartnerCell: UICollectionViewCell {
    private lazy var partnerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        addSubview(view)
        return view
    }()
    
    private lazy var partnerImageView: UIImageView = {
        let imageView = UIImageView()
        // TODO: 프로필 사진으로 교체
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFit
        partnerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var partnerSubview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.labelGrey
        view.layer.cornerRadius = 14
        view.layer.addSublayer(gradientLayer)
        partnerView.addSubview(view)
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        ]
        l.locations = [0, 1]
        l.startPoint = CGPoint(x: 0.25, y: 0.5)
        l.endPoint = CGPoint(x: 0.75, y: 0.5)
        l.cornerRadius = 14
        l.cornerCurve = .continuous
        return l
    }()

    private lazy var partnerName: UILabel = {
        let label = UILabel()
        label.text = "초록잎"
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        partnerSubview.addSubview(label)
        return label
    }()
    
    private lazy var partnerAge: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        partnerSubview.addSubview(label)
        return label
    }()
    
    private lazy var partnerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapGrey")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        partnerSubview.addSubview(imageView)
        return imageView
    }()
    
    private lazy var partnerDistance: UILabel = {
        let label = UILabel()
        label.text = "3 km"
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        partnerSubview.addSubview(label)
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

        partnerImageView.image = UIImage(systemName: "photo")
        partnerName.text = ""
        partnerAge.text = ""
        partnerDistance.text = ""
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = partnerSubview.bounds
    }
    
    
}

private extension PartnerCell {
    func configureLayout() {
        partnerName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerAge.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(84)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerMapImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
            $0.left.equalToSuperview().inset(22.48)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        partnerDistance.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        partnerSubview.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        partnerImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
        partnerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(partnerView.snp.width)
        }
    }
}
