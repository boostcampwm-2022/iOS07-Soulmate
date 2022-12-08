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
    
    static var footerKind = "Recommend-Footer-View"
    
    private lazy var recommendAgainButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.setTitle("한번 더 추천받기", for: .normal)
        button.setTitleColor(.messagePurple, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.borderPurple?.cgColor
        addSubview(button)
        button.addTarget(self, action: #selector(didTouchedButton), for: .touchUpInside)
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
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
    
    func configureButtonHandler(handler: @escaping () -> Void) {
        self.buttonTappedHandler = handler
    }
    
    func buttonTapPublisher() -> AnyPublisher<Void, Never> {
        return recommendAgainButton.tapPublisher()
    }
    
    @objc func didTouchedButton() {
        print("touch")
        buttonTappedHandler?()
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct aaaPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = RecommendFooterView(frame: .zero)
            return cell
        }.previewLayout(.device)
    }
}
#endif
