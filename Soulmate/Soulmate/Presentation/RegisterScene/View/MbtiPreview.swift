//
//  MbtiPreview.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/16.
//

import UIKit
import SnapKit

class MbtiPreview: UIView {
        
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        self.addSubview(stack)
        return stack
    }()
    
    lazy var innerTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 44)?.withWeight(700)
        label.textColor = .labelGrey
        label.textAlignment = .center
        hStackView.addSubview(label)
        return label
    }()
    
    lazy var recognizeTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 44)?.withWeight(700)
        label.textColor = .labelGrey
        label.textAlignment = .center
        hStackView.addSubview(label)
        return label
    }()
    
    lazy var judgementTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 44)?.withWeight(700)
        label.textColor = .labelGrey
        label.textAlignment = .center
        hStackView.addSubview(label)
        return label
    }()
    
    lazy var lifeStyleTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 44)?.withWeight(700)
        label.textColor = .labelGrey
        label.textAlignment = .center
        hStackView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MbtiPreview {
    
    func configureLayout() {
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        innerTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(38)
            $0.height.equalTo(53)
        }
        
        recognizeTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(innerTypeLabel.snp.trailing).offset(4)
            $0.width.equalTo(38)
            $0.height.equalTo(53)
        }
        
        judgementTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(recognizeTypeLabel.snp.trailing).offset(4)
            $0.width.equalTo(38)
            $0.height.equalTo(53)
        }
        
        lifeStyleTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(judgementTypeLabel.snp.trailing).offset(4)
            $0.width.equalTo(38)
            $0.height.equalTo(53)
        }
    }
    
    func changeInnerType(type: InnerType) {
        self.innerTypeLabel.text = type.rawValue.capitalized
        self.innerTypeLabel.textColor = .black
    }
    
    func changeRecognizeType(type: RecognizeType) {
        self.recognizeTypeLabel.text = type.rawValue.capitalized
        self.recognizeTypeLabel.textColor = .black
    }
    
    func changeJudgementType(type: JudgementType) {
        self.judgementTypeLabel.text = type.rawValue.capitalized
        self.judgementTypeLabel.textColor = .black
    }
    
    func changeLifeStyleType(type: LifeStyleType) {
        self.lifeStyleTypeLabel.text = type.rawValue.capitalized
        self.lifeStyleTypeLabel.textColor = .black
    }
}
