//
//  UnreadMessageCountBadge.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import UIKit

final class UnreadMessageCountBadge: UIView {
    lazy var counter: UILabel = {
        let label = UILabel(frame: .zero)
        self.addSubview(label)
        label.font = UIFont(name: "Poppins-Medium", size: 5)
        label.textColor = .white
        return label
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .mainPurple
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        counter.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
