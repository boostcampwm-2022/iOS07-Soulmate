//
//  HomeViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

import Then
import SnapKit

final class HomeViewController: UIViewController {
    // MARK: - UI
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.frame = CGRect(x: 0, y: 0, width: 140, height: 18)
        $0.contentMode = .scaleAspectFit
        self.view.addSubview($0)
    }
    
    private lazy var heart = UIImageView().then {
        $0.image = UIImage(named: "heart")
        $0.frame = CGRect(x: 0, y: 0, width: 17.07, height: 14.06)
        $0.contentMode = .scaleAspectFit
        self.view.addSubview($0)
    }
    
    private lazy var numOfHeartLabel = UILabel().then {
        $0.text = "00"
        $0.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        $0.textColor = UIColor(red: 0.364, green: 0.37, blue: 0.396, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        self.view.addSubview($0)
    }
    
    // MARK: - 후보1 UI
    private lazy var candidateUpperName = UILabel().then {
        $0.text = "초록잎"
        $0.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.view.addSubview($0)
    }
    
    private lazy var candidateUpperAge = UILabel().then {
        $0.text = "25"
        $0.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        self.view.addSubview($0)
    }
    
    private lazy var candidateUpperMapImageView = UIImageView().then {
        $0.image = UIImage(named: "mapGrey")
        $0.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        $0.contentMode = .scaleAspectFit
        self.view.addSubview($0)
    }
    
    private lazy var candidateUpperDistance = UILabel().then {
        $0.text = "3 km"
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        self.view.addSubview($0)
    }
    
    private lazy var candidateUpperView = UIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        $0.addSubview(candidateUpperName)
        $0.addSubview(candidateUpperAge)
        $0.addSubview(candidateUpperMapImageView)
        $0.addSubview(candidateUpperDistance)
        self.view.addSubview($0)
    }
    
    // MARK: - 후보2 UI
    private lazy var candidateLowerName = UILabel().then {
        $0.text = "파란잎"
        $0.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.view.addSubview($0)
    }
    
    private lazy var candidateLowerAge = UILabel().then {
        $0.text = "21"
        $0.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        self.view.addSubview($0)
    }
    
    private lazy var candidateLowerMapImageView = UIImageView().then {
        $0.image = UIImage(named: "mapGrey")
        $0.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        $0.contentMode = .scaleAspectFit
        self.view.addSubview($0)
    }
    
    private lazy var candidateLowerDistance = UILabel().then {
        $0.text = "21 km"
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        $0.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        self.view.addSubview($0)
    }
    
    private lazy var candidateLowerView = UIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        $0.addSubview(candidateLowerName)
        $0.addSubview(candidateLowerAge)
        $0.addSubview(candidateLowerMapImageView)
        $0.addSubview(candidateLowerDistance)
        self.view.addSubview($0)
    }
    
    private lazy var candidateStackView = UIStackView().then {
        $0.spacing = 16
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        self.view.addSubview($0)
    }
    
    // MARK: - 다시 추천 버튼
    private lazy var recommendAgainButton = UIButton(type: .system).then {
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        $0.frame = CGRect(x: 0, y: 0, width: 310, height: 22)
        $0.setTitle("한번 더 추천받기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.545, green: 0.275, blue: 0.949, alpha: 1), for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(red: 0.545, green: 0.275, blue: 0.949, alpha: 0.5).cgColor
        self.view.addSubview($0)
    }
    
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.width.equalTo(140)
            $0.height.equalTo(18)
        }
        
        heart.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-45.46)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18.97)
            $0.width.equalTo(17.07)
            $0.height.equalTo(14.06)
        }
        
        numOfHeartLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
        }
        
        recommendAgainButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(56)
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
        
        candidateStackView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(29)
            $0.bottom.equalTo(recommendAgainButton.snp.top).offset(-36)
            $0.left.right.equalToSuperview().inset(20)
        }
        
    }
}
