//
//  LoadingIndicator.swift
//  Soulmate
//
//  Created by termblur on 2022/11/28.
//

import UIKit

final class LoadingIndicator: UIActivityIndicatorView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(frame: .zero)
        configure()
    }
    
    private func configure() {
        self.color = UIColor.mainPurple
        self.hidesWhenStopped = true
        self.style = .large
        self.startAnimating()
    }
    
}
