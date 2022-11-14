//
//  LoginViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModel?
    
    private lazy var titleLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "logo")?.withShadow(
            blur: 3,
            offset: CGSize(width: 0, height: 2),
            color: .black
        )
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var welcomeGreetingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        
        var paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.25
        paragraphStyle.alignment = .center
        
        label.attributedText = NSMutableAttributedString(
            string: "소울메이트에 오신것을 환영합니다!\n아래 버튼을 눌러 시작해주세요.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitle("Apple로 시작하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "logoApple"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 150)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        self.view.addSubview(button)
        return button
    }()
    
    private lazy var phoneLoginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.brand200.cgColor
        button.setTitle("전화번호로 시작하기", for: .normal)
        button.setTitleColor(.brand300, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "Phone"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 135)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 24)
        
        self.view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    convenience init(viewModel: LoginViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureView()
        configureLayout()
    }
}

// MARK: - View Generators

private extension LoginViewController {
    
    func bind() {
        
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {

        titleLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(117)
        }
        
        emojiImageView.snp.makeConstraints {
            $0.center.equalTo(self.view.safeAreaLayoutGuide.snp.center)
        }
        
        phoneLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(phoneLoginButton.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
        
        welcomeGreetingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-24)
        }
    }
}

// TODO: Color asset 만들고 지울것
extension UIColor {
    static let brand200 = UIColor(red: 198.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: 1)
    static let brand300 = UIColor(red: 139.0/255.0, green: 70.0/255.0, blue: 242.0/255.0, alpha: 1)
}
