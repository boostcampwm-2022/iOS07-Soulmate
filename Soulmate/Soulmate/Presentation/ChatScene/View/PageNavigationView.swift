//
//  PageNavigationView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import UIKit
import SnapKit

final class PageNavigationView: UIView {
    
    private lazy var pageStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with titles: [String]) {
        titles.forEach { title in
            let navItem = PageNavItemView(with: title)
            pageStackView.addArrangedSubview(navItem)
        }
    }
    
    func setPage(index: Int) {
        guard index < pageStackView.arrangedSubviews.count else { return }
        
        for i in 0..<pageStackView.arrangedSubviews.count {
            guard let item = pageStackView.arrangedSubviews[i] as? PageNavItemView else { return }
            
            if i == index {
                item.activate()
            } else {
                item.deActivate()
            }
        }
    }
}

private extension PageNavigationView {
    func configureLayout() {
        
        pageStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
}

final class PageNavItemView: UIView {
    
    private var title: String?
    
    private var itemButton: UIButton?
    
    private lazy var underLine: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        line.widthAnchor.constraint(equalToConstant: 30).isActive = true
        line.heightAnchor.constraint(equalToConstant: 3).isActive = true

        return line
    }()
    
    private lazy var itemStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with string: String) {
        self.init()
        self.title = string
        itemButton = UIButton()
        var config = UIButton.Configuration.plain()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.labelGrey ?? .black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        config.attributedTitle = AttributedString(
            NSAttributedString(
                string: string,
                attributes: attributes
            )
        )
        itemButton?.configuration = config
        
        guard let itemButton else { return }

        itemStackView.addArrangedSubview(itemButton)
        itemStackView.addArrangedSubview(underLine)
        
        configureLayout()
    }
    
    func activate() {
        underLine.isHidden = false
        
        var config = UIButton.Configuration.plain()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        config.attributedTitle = AttributedString(
            NSAttributedString(
                string: title ?? " ",
                attributes: attributes
            )
        )
        itemButton?.configuration = config
    }
    
    func deActivate() {
        underLine.isHidden = true
        
        var config = UIButton.Configuration.plain()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.labelGrey ?? .systemGray4,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        config.attributedTitle = AttributedString(
            NSAttributedString(
                string: title ?? " ",
                attributes: attributes
            )
        )
        itemButton?.configuration = config
    }
}


private extension PageNavItemView {
    func configureLayout() {
        itemStackView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
}
