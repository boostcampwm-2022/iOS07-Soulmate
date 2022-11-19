//
//  MbtiSegmentView.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/16.
//

import UIKit
import SnapKit

class MbtiSegmentView: UIView {

    let leftTitle: String = ""
    let rightTitle: String = ""
    @Published var seletedMbti = String()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        self.addSubview(stack)
        return stack
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .symbolGrey
        button.setTitle(leftTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        button.addAction(UIAction { _ in self.leftButtonTapped() }, for: .touchUpInside)
        self.hStackView.addArrangedSubview(button)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .symbolGrey
        button.setTitle(rightTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        button.addAction(UIAction { _ in self.rightButtonTapped() }, for: .touchUpInside)
        self.hStackView.addArrangedSubview(button)
        self.hStackView.addArrangedSubview(button)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(titles: (String, String)) {
        self.init(frame: .zero)
        leftButton.setTitle(titles.0, for: .normal)
        rightButton.setTitle(titles.1, for: .normal)
    }
    
}

private extension MbtiSegmentView {
    
    func configureLayout() {
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(50)
        }
        
        leftButton.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
    }
    
    func leftButtonTapped() {
        leftButton.backgroundColor = .mainPurple
        leftButton.setTitleColor(.white, for: .normal)
        rightButton.backgroundColor = .symbolGrey
        rightButton.setTitleColor(.black, for: .normal)
        self.seletedMbti = self.leftButton.titleLabel?.text ?? ""
    }

    func rightButtonTapped() {
        rightButton.backgroundColor = .mainPurple
        rightButton.setTitleColor(.white, for: .normal)
        leftButton.backgroundColor = .symbolGrey
        leftButton.setTitleColor(.black, for: .normal)
        self.seletedMbti = self.rightButton.titleLabel?.text ?? ""
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MbtiSegmentViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let preview = MbtiSegmentView(titles: ("I", "E"))
            return preview
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
