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
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        let attr: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        let attrString = NSAttributedString(string: title, attributes: attr)
        config.attributedTitle = AttributedString(attrString)
        config.baseBackgroundColor = UIColor.gray
        self.configuration = config        
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
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
            UIColor.gradientPurple?.cgColor ?? UIColor.black.cgColor,
            UIColor.gradientBlue?.cgColor ?? UIColor.black.cgColor
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
