//
//  IntroductionSettingViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit
import SnapKit
import Combine

final class IntroductionSettingViewController: UIViewController {
    
    var viewFrame: CGRect?
    var bag = Set<AnyCancellable>()
    var viewModel: RegisterIntroductionViewModel?
    
    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        view.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.goToNextStep()
        
        return bar
    }()
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님을 자유롭게\n소개해주세요."
        )
        view.addSubview(headerView)
        return headerView
    }()
    
    private lazy var introductionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.layer.cornerCurve = .continuous
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textView.textContainerInset = .init(top: 16, left: 12, bottom: 0, right: 12)
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }()
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/50"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        label.textColor = .labelDarkGrey
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var introductionStackView: UIStackView = {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.addArrangedSubview(textCountLabel)
        stackView.addArrangedSubview(introductionTextView)
        
        return stackView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = GradientButton(title: "다음")
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: RegisterIntroductionViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstants()
        configureView()
        configureLayout()
        bind()
    }
}

extension IntroductionSettingViewController: ProgressAnimatable {
    func preset() {
        progressBar.isHidden = true
        nextButton.isHidden = true
        view.backgroundColor = .clear
    }
    
    func setPushInitStateAsTo() {
        guard let viewFrame else { return }
        
        view.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: viewFrame.midY)
    }
    
    func setPushFinalStateAsTo() {
        guard let viewFrame else { return }
        
        view.center = CGPoint(
            x: viewFrame.midX,
            y: viewFrame.midY)
    }
    
    func setPushInitStateAsFrom() {
        guard let viewFrame else { return }
        
        view.center = CGPoint(
            x: viewFrame.midX,
            y: viewFrame.midY)
    }
    
    func setPushFinalStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        introductionStackView.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: introductionStackView.frame.midY)
    }
    
    func setPopInitStateAsTo() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        introductionStackView.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: introductionStackView.frame.midY)
    }
    
    func setPopFinalStateAsTo() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX,
            y: registerHeaderStackView.frame.midY)
        
        introductionStackView.center = CGPoint(
            x: viewFrame.midX,
            y: introductionStackView.frame.midY)
    }
    
    func setPopInitStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX,
            y: registerHeaderStackView.frame.midY)
        
        introductionStackView.center = CGPoint(
            x: viewFrame.midX,
            y: introductionStackView.frame.midY)
    }
    
    func setPopFinalStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        introductionStackView.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: introductionStackView.frame.midY)
    }
    
    func reset() {
        progressBar.isHidden = false
        nextButton.isHidden = false
        view.backgroundColor = .white
    }
}

private extension IntroductionSettingViewController {
    
    func bind() {
    }
    
    func setConstants() {
        viewFrame = view.frame
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(54)
        }
        
        introductionStackView.snp.makeConstraints {
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.top.equalTo(self.registerHeaderStackView.snp.bottom).offset(60)
        }
    }
}

#if DEBUG
import SwiftUI
struct IntroductionSettingViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        IntroductionSettingViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                IntroductionSettingViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
