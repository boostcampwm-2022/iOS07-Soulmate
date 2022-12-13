//
//  PageNavigationView.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import UIKit
import SnapKit

protocol PageChangeDelegate: AnyObject {
    func goToPage(by index: Int)
}

final class PageNavigationView: UIView {
    
    weak var hostView: UIView?
    
    private lazy var pageStackView: UIStackView = {
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        hostView?.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "slider.horizontal.3")?
            .withRenderingMode(.alwaysTemplate)        
        button.tintColor = .darkGray
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]

        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            NSAttributedString(string: "", attributes: attributes)
        )
        config.titleAlignment = .trailing
        config.image = image
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = config
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        hostView: UIView,
        with titles: [String],
        delegate: PageChangeDelegate,
        editModeToggle: (() -> ())?) {
            
            self.hostView = hostView
            
            for (index, title) in titles.enumerated() {
                let navItem = PageNavItemView(
                    with: title,
                    index: index
                )
                navItem.delegate = delegate
                pageStackView.addArrangedSubview(navItem)
            }
            
            editButton.addAction(
                UIAction { _ in
                    editModeToggle?()
                },
                for: .touchUpInside)
            
            configureLayout()
    }
    
    func setPage(index: Int) {
        guard index < pageStackView.arrangedSubviews.count else { return }
        
        if index == 0 {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
        
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
        
        guard let hostView else { return }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(pageStackView.snp.centerY)
            $0.right.equalTo(hostView.snp.right).offset(-20)
        }
    }
}

final class PageNavItemView: UIView {
    
    weak var delegate: PageChangeDelegate?
    
    private var title: String?
    private var index: Int?
    
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
    
    convenience init(with string: String, index: Int) {
        self.init()
        self.title = string
        self.index = index
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
        itemButton?.addAction(
            UIAction { [weak self] _ in
                self?.delegate?.goToPage(by: index)
            },
            for: .touchUpInside
        )
        
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
