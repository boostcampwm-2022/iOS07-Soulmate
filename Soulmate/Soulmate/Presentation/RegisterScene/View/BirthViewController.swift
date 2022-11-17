//
//  BirthViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/16.
//

import UIKit
import Combine

final class BirthViewController: UIViewController {

    var viewFrame: CGRect?
    var bag = Set<AnyCancellable>()
    
    var viewModel: RegisterBirthViewModel?
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님의 생일은\n언제인가요?",
            descriptionText: "나이 표시에 사용되며, 언제든 변경 가능해요"
        )
        view.addSubview(headerView)
        return headerView
    }()
    
    private lazy var birthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        self.view.addSubview(picker)
        return picker
    }()
    
    
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        self.view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: RegisterBirthViewModel) {
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

extension BirthViewController: ProgressAnimatable {
    func preset() {
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
        
        birthPicker.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: birthPicker.frame.midY)
    }
    
    func setPopInitStateAsTo() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        birthPicker.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: birthPicker.frame.midY)
    }
    
    func setPopFinalStateAsTo() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX,
            y: registerHeaderStackView.frame.midY)
        
        birthPicker.center = CGPoint(
            x: viewFrame.midX,
            y: birthPicker.frame.midY)
    }
    
    func setPopInitStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX,
            y: registerHeaderStackView.frame.midY)
        
        birthPicker.center = CGPoint(
            x: viewFrame.midX,
            y: birthPicker.frame.midY)
    }
    
    func setPopFinalStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        birthPicker.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: birthPicker.frame.midY)
    }
    
    func reset() {
        nextButton.isHidden = false
        view.backgroundColor = .white
    }
}

private extension BirthViewController {
    
    func bind() {
        
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: RegisterBirthViewModel.Input(
                didChangedBirthDate: birthPicker.datePublisher(),
                didTappedNextButton: nextButton.tapPublisher()
            )
        )
    }
    
    func setConstants() {
        viewFrame = view.frame
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {

        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        birthPicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(33)
            $0.height.equalTo(54)
        }
        
    }
}


#if DEBUG
import SwiftUI
struct BirthViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        BirthViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                BirthViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
