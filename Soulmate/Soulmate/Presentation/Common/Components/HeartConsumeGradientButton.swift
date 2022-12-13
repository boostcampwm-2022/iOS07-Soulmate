//
//  HeartConsumeGradientButton.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/14.
//

import UIKit
import SnapKit

final class HeartConsumeGradientButton: GradientButton {
    
    enum ButtonState {
        case guide
        case heart
    }
    
    var currentState: ButtonState = .guide
    var title: String?
    
    private var buttonTappedHandler: (() -> Void)?
    
    override func configure(title: String) {
                
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.mainPurple?.cgColor
        
        guideMode()
        
        self.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTouchedButtonDown), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchCancel)
        self.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchDragExit)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title = title
        configure(title: title)
        setTouchUpInsideAction()
    }
    
    func configureButtonHandler(handler: @escaping () -> Void) {
        self.buttonTappedHandler = handler
    }
}

private extension HeartConsumeGradientButton {
    
    func setTouchUpInsideAction() {
        self.addAction(
            UIAction { [weak self] _ in
                if self?.currentState == .heart {
                    self?.buttonTappedHandler?()
                }
                
                self?.toggleState()
            },
            for: .touchUpInside
        )
    }
    
    func toggleState() {
        if currentState == .guide {
            heartMode()
            currentState = .heart
        } else {
            guideMode()
            currentState = .guide
        }
    }
    
    func guideMode() {
        var config = UIButton.Configuration.plain()
        let text = title ?? ""
        let nsStr = NSMutableAttributedString(string: text)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        nsStr.addAttributes(
            attrs
            , range: (text as NSString).range(of: text))
        config.attributedTitle = AttributedString(nsStr)
        
        self.configuration = config
        
        self.layer.borderWidth = 0
        
        gradientLayer.isHidden = false
        layoutIfNeeded()
    }
    
    func heartMode() {
        
        var config = UIButton.Configuration.plain()
        let text = "-10"
        let nsStr = NSMutableAttributedString(string: text)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.labelDarkGrey ?? .black
        ]
        nsStr.addAttributes(
            attrs
            , range: (text as NSString).range(of: text))
        config.attributedTitle = AttributedString(nsStr)
        config.image = UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal)
        config.imagePadding = 10
        
        self.configuration = config
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.labelDarkGrey?.cgColor
        
        gradientLayer.isHidden = true
        layoutIfNeeded()
    }
}
