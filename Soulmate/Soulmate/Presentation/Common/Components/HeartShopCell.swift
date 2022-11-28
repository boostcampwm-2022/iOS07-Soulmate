//
//  HeartShopCell.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/27.
//

import UIKit
import SnapKit

class HeartShopCell: SelectableCell {
    
    static let identifier = "HeartShopCell"
    
    private lazy var heartImageView: UIImageView = {
        let image = UIImage(named: "heart")
        let imageView = UIImageView(image: image?.resized(to: CGSize(width: 25, height: 25)))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var heartQuantity: UILabel = {
        let label = UILabel()
        label.text = "0개"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.addSubview(label)
        return label
    }()
    
    lazy var heartPrice: UILabel = {
        let label = UILabel()
        label.text = "00,000원"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.hideCheckView()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(quantityLabel: String, priceLabel: String) {
        self.init(frame: .zero)
        self.heartQuantity.text = quantityLabel
        self.heartPrice.text = priceLabel
    }
    
    private func layout() {
        heartImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(26)
        }
        
        heartQuantity.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(heartImageView.snp.trailing).offset(8)
        }
        
        heartPrice.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct HeartShopCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let cell = HeartShopCell(
                quantityLabel: "50개",
                priceLabel: "30,000원"
            )
            return cell
        }.previewLayout(.fixed(width: 350, height: 72))
    }
}
#endif
