//
//  RecommendFooterView.swift
//  Soulmate
//
//  Created by termblur on 2022/11/30.
//

import UIKit
import Combine

import SnapKit

final class RecommendFooterView: UICollectionReusableView {
    private var cancellable: AnyCancellable?
    
    private lazy var recommendAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.setTitle("한번 더 추천받기", for: .normal)
        button.setTitleColor(UIColor.messagePurple, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.borderPurple?.cgColor
        addSubview(button)
        return button
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
        recommendAgainButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct RecommendFooterViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let preview = RecommendFooterView()
            return preview
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
