//
//  RecommendView.swift
//  Soulmate
//
//  Created by termblur on 2022/12/02.
//

import UIKit
import Combine
import SnapKit

final class RecommendFooterView: UICollectionReusableView {
    
    enum ButtonState {
        case guide
        case heart
    }
    
    static var footerKind = "Recommend-Footer-View"
    
    private var state: ButtonState = .guide
    
    private lazy var recommendAgainButton: UIButton = {
        let button = UIButton(frame: .zero)
        guideMode(button)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.mainPurple?.cgColor
        addSubview(button)
        button.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchedButtonDown), for: .touchDown)
        button.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchCancel)
        button.addTarget(self, action: #selector(didTouchedButtonUp), for: .touchDragExit)
        return button
    }()
    
    private var buttonTappedHandler: (() -> Void)?
    
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
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
    
    func configureButtonHandler(handler: @escaping () -> Void) {
        self.buttonTappedHandler = handler
    }
    
    @objc func didTouchedButtonUp() {
        
        if state == .heart {
            buttonTappedHandler?()
        }
        
        toggleState()
        
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

private extension RecommendFooterView {
    func toggleState() {
        if state == .guide {
            heartMode(recommendAgainButton)
            state = .heart
        } else {
            guideMode(recommendAgainButton)
            state = .guide
        }
    }
    
    func guideMode(_ button: UIButton) {
        
        var config = UIButton.Configuration.plain()
        let text = "한번 더 추천받기"
        let nsStr = NSMutableAttributedString(string: text)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.mainPurple ?? .black
        ]
        nsStr.addAttributes(
            attrs
            , range: (text as NSString).range(of: text))
        config.attributedTitle = AttributedString(nsStr)
        
        button.configuration = config
        
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor.mainPurple?.cgColor
    }
    
    func heartMode(_ button: UIButton) {
        
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
        
        button.configuration = config
        
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.labelDarkGrey?.cgColor
    }
}
