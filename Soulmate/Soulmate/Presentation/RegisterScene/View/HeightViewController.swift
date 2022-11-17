//
//  HeightViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/16.
//

import UIKit

final class HeightViewController: UIViewController {
    
    var viewFrame: CGRect?
    var viewModel: RegisterHeightViewModel?
    
    // TODO: 이부분 상의하고 수정
    @Published var selectedHeight: String = String()
    
    private let pickerData: [Int] = Array(140...210) // 키 범위
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님의 키를\n입력해주세요.",
            descriptionText: "신장 표시에 사용되며, 언제든 변경 가능해요"
        )
        view.addSubview(headerView)
        return headerView
    }()
    
    private lazy var heightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(30, inComponent: 0, animated: true)
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
    
    convenience init(viewModel: RegisterHeightViewModel) {
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

extension HeightViewController: ProgressAnimatable {
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
        
        heightPicker.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: heightPicker.frame.midY)
    }
    
    func setPopInitStateAsTo() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        heightPicker.center = CGPoint(
            x: viewFrame.midX - viewFrame.maxX,
            y: heightPicker.frame.midY)
    }
    
    func setPopFinalStateAsTo() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX,
            y: registerHeaderStackView.frame.midY)
        
        heightPicker.center = CGPoint(
            x: viewFrame.midX,
            y: heightPicker.frame.midY)
    }
    
    func setPopInitStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX,
            y: registerHeaderStackView.frame.midY)
        
        heightPicker.center = CGPoint(
            x: viewFrame.midX,
            y: heightPicker.frame.midY)
    }
    
    func setPopFinalStateAsFrom() {
        guard let viewFrame else { return }
        
        registerHeaderStackView.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: registerHeaderStackView.frame.midY)
        
        heightPicker.center = CGPoint(
            x: viewFrame.midX + viewFrame.maxX,
            y: heightPicker.frame.midY)
    }
    
    func reset() {
        nextButton.isHidden = false
        view.backgroundColor = .white
    }
}

private extension HeightViewController {
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: RegisterHeightViewModel.Input(
                didChangedHeightValue: $selectedHeight.eraseToAnyPublisher(),
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
        
        heightPicker.snp.makeConstraints {
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

extension HeightViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedHeight = String(pickerData[row])
    }
    
}

#if DEBUG
import SwiftUI
struct HeightViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        HeightViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                HeightViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
