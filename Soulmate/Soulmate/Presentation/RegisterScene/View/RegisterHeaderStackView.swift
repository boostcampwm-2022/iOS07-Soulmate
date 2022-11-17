//
//  RegisterHeaderStackView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import UIKit

class RegisterHeaderStackView: UIStackView {
    
    lazy var guideLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        
        self.addArrangedSubview(label)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
                
        self.addArrangedSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .equalSpacing
        self.spacing = 12
    }
    
    func setMessage(guideText: String, descriptionText: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.33
        paragraphStyle.alignment = .left
        
        guideLabel.attributedText = NSMutableAttributedString(
            string: guideText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        guard let descriptionText = descriptionText else {
            descriptionLabel.isHidden = true
            return
        }
        descriptionLabel.isHidden = false
        descriptionLabel.text = descriptionText
    }

}
