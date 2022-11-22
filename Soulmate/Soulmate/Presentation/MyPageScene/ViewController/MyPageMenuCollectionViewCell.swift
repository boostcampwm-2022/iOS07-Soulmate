//
//  MyPageMenuCollectionViewCell.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/22.
//

import UIKit
import SnapKit

class MyPageMenuCollectionViewCell: UICollectionViewCell {
    
    lazy var symbol: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
        label.textColor = .black
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()
    
    lazy var trailingDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.textColor = .gray
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        symbol.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(24)
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(symbol.snp.trailing).offset(17)
        }
        
        trailingDescription.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageMenuCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let preview = MyPageMenuCollectionViewCell()
            return preview
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
