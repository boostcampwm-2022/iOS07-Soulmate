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
        return view
    }()
    
    private lazy var partnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = nil
        imageView.layer.cornerRadius = 14
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        partnerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var loadingIndicator: LoadingIndicator = {
       let loading = LoadingIndicator()
        partnerImageView.addSubview(loading)
        return loading
    }()
    
    private lazy var partnerSubview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 14
        view.layer.addSublayer(gradientLayer)
        partnerView.addSubview(view)
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
        partnerSubview.addSubview(label)
        return label
    }()
    
    private lazy var partnerAge: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        partnerSubview.addSubview(label)
        return label
    }()
    
    private lazy var partnerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapGrey")
        imageView.contentMode = .scaleAspectFit
        partnerSubview.addSubview(imageView)
        return imageView
    }()
    
    private lazy var partnerDistance: UILabel = {
        let label = UILabel()
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

        partnerImageView.image = nil
        partnerName.text = "-"
        partnerAge.text = "-"
        partnerDistance.text = "-"
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = partnerSubview.bounds
    }
    
    func fill(previewViewModel: HomePreviewViewModel) {
        self.partnerName.text = previewViewModel.name
        self.partnerAge.text = previewViewModel.age
        self.partnerDistance.text = previewViewModel.distance
    }
    
    func fill(userImage: UIImage) {
        let ratio = userImage.size.width / self.contentView.frame.width

        self.partnerImageView.image = userImage.resized(to: CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height * ratio))
        loadingIndicator.stopAnimating()
    }
    
}

private extension PartnerCell {
    func configureLayout() {
        
        partnerImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
        
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
        
        partnerSubview.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        partnerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(partnerView.snp.width)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PartenerCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let preview = PartnerCell()
            return preview
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
