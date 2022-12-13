//
//  CandidatesCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/14.
//

import UIKit
import CoreLocation
import SnapKit

final class PartnerCell: UICollectionViewCell {
    
    private lazy var partnerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        addSubview(view)
        view.isRecursiveSkeletonable = true
        view.isSkeletonAnimatable = false
        return view
    }()
    
    private lazy var partnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        imageView.layer.cornerRadius = 14
        imageView.layer.cornerCurve = .continuous
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        partnerView.addSubview(imageView)
        imageView.isRecursiveSkeletonable = true
        imageView.isSkeletonAnimatable = false

        return imageView
    }()

    private lazy var partnerSubview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 14
        view.layer.addSublayer(gradientLayer)
        partnerView.addSubview(view)
        view.isRecursiveSkeletonable = true
        view.isSkeletonAnimatable = false

        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        return layer
    }()

    private lazy var partnerName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        label.isRecursiveSkeletonable = true
        label.isSkeletonAnimatable = false
        
        return label
    }()
    
    private lazy var partnerAge: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        label.isRecursiveSkeletonable = true
        label.isSkeletonAnimatable = false

        return label
    }()
    
    private lazy var partnerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapGrey")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var partnerAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.isRecursiveSkeletonable = true
        label.isSkeletonAnimatable = false

        return label
    }()
    
    private lazy var partnerDistance: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.isRecursiveSkeletonable = true
        label.isSkeletonAnimatable = false
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        self.isRecursiveSkeletonable = true
        self.isSkeletonAnimatable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        partnerImageView.image = nil
        partnerName.text = nil
        partnerAge.text = nil
        partnerAddressLabel.text = nil
        partnerDistance.text = nil
        
        partnerMapImageView.isHidden = true
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = partnerSubview.bounds
        
        if isRecursiveSkeletonable {
            skeletonLayoutSubviews()
        }
    }
    
    func activateSkeleton() {
        self.showSkeleton()
    }
    
    func deactivateSkeleton() {
        self.hideSkeleton()
    }
    
    func fill(previewViewModel: HomePreviewViewModel) {
        self.partnerName.text = previewViewModel.name
        self.partnerAge.text = previewViewModel.age
        self.partnerAddressLabel.text = previewViewModel.address ?? "위치 정보 없음"
        self.partnerDistance.text = previewViewModel.distance
        
        self.partnerMapImageView.isHidden = false
    }
    
    func fill(userImage: UIImage) {
        self.partnerImageView.image = userImage
    }
}

private extension PartnerCell {
    func configureLayout() {
        
        partnerImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
        partnerSubview.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        partnerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(partnerView.snp.width)
        }

        configureUpperLabelStackViewLayout()
        configureLowerLabelStackViewLayout()
    }
    
    func configureUpperLabelStackViewLayout() {
        let upperLabelStackView = UIStackView(frame: .zero)
        upperLabelStackView.axis = .horizontal
        upperLabelStackView.alignment = .leading
        upperLabelStackView.distribution = .equalSpacing
        upperLabelStackView.spacing = 6
        [partnerName, partnerAge].forEach {
            upperLabelStackView.addArrangedSubview($0)
        }
        partnerSubview.addSubview(upperLabelStackView)
        upperLabelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
            $0.width.lessThanOrEqualTo(300)
        }
        
        upperLabelStackView.isRecursiveSkeletonable = true
        upperLabelStackView.isSkeletonAnimatable = true
        upperLabelStackView.skeletonAnimationType = .gradient
    }
    
    func configureLowerLabelStackViewLayout() {
        let lowerLabelStackView = UIStackView(frame: .zero)
        lowerLabelStackView.axis = .horizontal
        lowerLabelStackView.alignment = .leading
        lowerLabelStackView.distribution = .equalSpacing
        lowerLabelStackView.spacing = 6
        [partnerMapImageView, partnerAddressLabel, partnerDistance].forEach {
            lowerLabelStackView.addArrangedSubview($0)
        }
        
        partnerSubview.addSubview(lowerLabelStackView)
        
        partnerMapImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(18)
        }
        
        lowerLabelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
            $0.width.lessThanOrEqualTo(300)
        }
        
        lowerLabelStackView.isRecursiveSkeletonable = true
        lowerLabelStackView.isSkeletonAnimatable = true
        lowerLabelStackView.skeletonAnimationType = .gradient
    }
}



