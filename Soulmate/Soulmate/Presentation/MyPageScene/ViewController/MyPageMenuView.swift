//
//  MyPageMenuView.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/22.
//

import UIKit
import SnapKit

class MyPageMenuView: UIView {
    
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
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(symbolName: String, titleName: String, trailingText: String) {
        self.init(frame: .zero)
        self.symbol.image = UIImage(named: symbolName)
        self.title.text = titleName
        self.trailingDescription.text = trailingText
    }
    
    public func layout() {
        
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

struct MyPageMenuPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let preview = MyPageMenuView(symbolName: "AppIcon", titleName: "버전정보", trailingText: "v 3.2.20")
            return preview
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
