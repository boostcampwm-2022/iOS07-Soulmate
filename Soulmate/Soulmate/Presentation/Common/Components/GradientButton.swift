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
    
    func configure(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .gray
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTouchedButtonDown), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchCancel)
        self.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchDragExit)
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
    
    lazy var gradientLayer: CAGradientLayer = {
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
    
    @objc func didTouchedButtonUp() {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.transform = .identity
            self.alpha = 1
        })
    }
    
    @objc func didTouchedButtonDown() {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.transform = .init(scaleX: 0.97, y: 0.97)
            self.alpha = 0.97
        })
    }
}
