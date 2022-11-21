//
//  MyPageViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit

final class MyPageView: UIView {
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        self.addSubview(view)
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImage(named: "heart")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 78
        imageView.layer.borderWidth = 6
        imageView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(imageView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        self.backgroundColor = .myPageGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(174)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(contentView.snp.top)
            $0.width.height.equalTo(156)
        }
        
    }
    
}

final class MyPageViewController: UIViewController {
    
    lazy var contentView = MyPageView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // binding
        // viewModel -> view
        // view -> viewModel
    }
    
    
}
