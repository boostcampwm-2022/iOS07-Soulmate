//
//  GradientButton.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/11.
//

import UIKit

class GradientButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .gray
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        configure(title: title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isEnabled == false {
            gradientLayer.frame = .null
        } else {
            gradientLayer.frame = bounds
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [
            UIColor(red: 0.647, green: 0.204, blue: 0.961, alpha: 1).cgColor,
            UIColor(red: 0.325, green: 0.408, blue: 0.914, alpha: 1).cgColor
        ]
        l.locations = [0, 1]
        l.startPoint = CGPoint(x: 0.4, y: 0.5)
        l.endPoint = CGPoint(x: 0.75, y: 0.5)
        l.cornerRadius = 12
        l.cornerCurve = .continuous
        layer.insertSublayer(l, at: 0)
        return l
    }()
    
}
