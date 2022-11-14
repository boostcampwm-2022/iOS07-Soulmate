//
//  HomeViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

import SnapKit

final class HomeViewController: UIViewController {
    // MARK: - UI
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 18)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var heart: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.frame = CGRect(x: 0, y: 0, width: 17.07, height: 14.06)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()

    
    private lazy var numOfHeartLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        label.textColor = UIColor.labelDarkGrey
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        self.view.addSubview(label)
        return label
    }()
    
    // MARK: - 후보1 UI
    private lazy var candidateUpperName: UILabel = {
        let label = UILabel()
        label.text = "초록잎"
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        candidateUpperView.addSubview(label)
        return label
    }()
    
    private lazy var candidateUpperAge: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        candidateUpperView.addSubview(label)
        return label
    }()
    
    private lazy var candidateUpperMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapGrey")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        candidateUpperView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var candidateUpperDistance: UILabel = {
        let label = UILabel()
        label.text = "3 km"
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        candidateUpperView.addSubview(label)
        return label
    }()
    
    private lazy var candidateUpperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = UIColor.backgroundGrey
        candidateStackView.addArrangedSubview(view)
        return view
    }()
    
    // MARK: - 후보2 UI
    private lazy var candidateLowerName: UILabel = {
        let label = UILabel()
        label.text = "파란잎"
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        candidateLowerView.addSubview(label)
        return label
    }()
    
    private lazy var candidateLowerAge: UILabel = {
        let label = UILabel()
        label.text = "21"
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        candidateLowerView.addSubview(label)
        return label
    }()
    
    private lazy var candidateLowerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapGrey")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        candidateLowerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var candidateLowerDistance: UILabel = {
        let label = UILabel()
        label.text = "21 km"
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        candidateLowerView.addSubview(label)
        return label
    }()
    
    private lazy var candidateLowerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = UIColor.backgroundGrey
        candidateStackView.addArrangedSubview(view)
        return view
    }()
    
    private lazy var candidateStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        self.view.addSubview(stack)
        return stack
    }()
    
    // MARK: - 다시 추천 버튼
    private lazy var recommendAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.frame = CGRect(x: 0, y: 0, width: 310, height: 22)
        button.setTitle("한번 더 추천받기", for: .normal)
        button.setTitleColor(UIColor.messagePurple, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.borderPurple?.cgColor
        self.view.addSubview(button)
        return button
    }()
    
    // MARK: - 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
    
}

// MARK: - View Generators

private extension HomeViewController {
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        logo.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.snp.top).offset(64)
            $0.width.equalTo(140)
            $0.height.equalTo(18)
        }
        
        heart.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-45.46)
            $0.top.equalTo(view.snp.top).offset(72.97)
            $0.width.equalTo(17.07)
            $0.height.equalTo(14.06)
        }
        
        numOfHeartLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(view.snp.top).offset(71)
        }
        
        recommendAgainButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(54)
        }
        
        [candidateUpperName, candidateLowerName].forEach {
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(50)
            }
        }
        
        [candidateUpperAge, candidateLowerAge].forEach {
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().inset(84)
                $0.bottom.equalToSuperview().inset(50)
            }
        }
        
        [candidateUpperMapImageView, candidateLowerMapImageView].forEach {
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().inset(22.48)
                $0.bottom.equalToSuperview().inset(25)
            }
        }
        
        [candidateUpperDistance, candidateLowerDistance].forEach {
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().inset(44)
                $0.bottom.equalToSuperview().inset(24)
            }
        }
        
        [candidateUpperView, candidateLowerView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(candidateUpperView.snp.height)
            }
        }
        
        candidateStackView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(29)
            $0.bottom.equalTo(recommendAgainButton.snp.top).offset(-36)
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().inset(20)
        }
        
    }
}
