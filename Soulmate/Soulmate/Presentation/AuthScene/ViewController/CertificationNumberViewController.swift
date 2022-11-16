//
//  CertificationNumberViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit
import SnapKit
import Combine

final class CertificationNumberViewController: UIViewController {
    
    var viewModel: CertificationViewModel?
    
    var bag = Set<AnyCancellable>()
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드를 \n입력해주세요"
        label.numberOfLines = 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 35.2
        paragraphStyle.minimumLineHeight = 35.2
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSMutableAttributedString(
            string: label.text ?? "",
            attributes: attr)
        label.attributedText = attrString
        var font = UIFont(name: "Apple SD Gothic Neo", size: 22)?.withWeight(700)
        var descriptor = font?.fontDescriptor
        
        
        label.font = font
        
        return label
    }()
    
    private lazy var userPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "01012345678"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 22.4
        paragraphStyle.minimumLineHeight = 22.4
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSMutableAttributedString(
            string: label.text ?? "",
            attributes: attr)
        label.attributedText = attrString
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 14)?.withWeight(600)
        // TODO: 색 올바르게 조정해야 함
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var resendButton: UIButton = {
        let button = UIButton()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 22.4
        paragraphStyle.minimumLineHeight = 22.4
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 14)?.withWeight(700) ?? UIFont(),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSAttributedString(string: "재전송", attributes: attr)
        button.setAttributedTitle(attrString, for: .normal)
        
        return button
    }()
    
    private lazy var phoneNumAndResendButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        stackView.addArrangedSubview(userPhoneNumberLabel)
        stackView.addArrangedSubview(resendButton)
        
        return stackView
    }()
    
    private lazy var guideLabelAndPhoneNumberStackView: UIStackView = {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(guideLabel)
        stackView.addArrangedSubview(phoneNumAndResendButtonStackView)
        
        return stackView
    }()
    
    private var certificationFields = [
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField(),
        CertificationTextField()
    ]
    
    private lazy var certificationFieldClearTouchView: UIButton = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = .clear

        view.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        return view
    }()
    
    // TODO: 크기 기기 사이즈에 맞춰서 조절 되어야 함.
    private lazy var numStackView: UIStackView = {
        let stackView = UIStackView()
        view.addSubview(stackView)
        view.addSubview(certificationFieldClearTouchView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        certificationFields.forEach { certificationField in
            let underLinedView = self.underLinedView(textField: certificationField)
            stackView.addArrangedSubview(underLinedView)
        }
                
        return stackView
    }()
    
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: CertificationViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureView()
        
        bind()
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        for field in certificationFields {
            guard let text = field.text,
                  !text.isEmpty else {
                field.becomeFirstResponder()
                return
            }
        }
        
        guard let lastField = certificationFields.last else { return }
        lastField.becomeFirstResponder()
    }
}

// MARK: - Private functions

private extension CertificationNumberViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }

        userPhoneNumberLabel.text = viewModel.phoneNumber
        
        var certificationFieldPublisher = certificationFields[0]
            .textPublisher()
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        for i in 1..<certificationFields.count {
            certificationFieldPublisher = certificationFieldPublisher
                .combineLatest(
                    certificationFields[i]
                    .textPublisher()
                    .compactMap { $0 }
                    .eraseToAnyPublisher()
                )
                .map { (value1, value2) in
                    return value1 + value2
                }
                .eraseToAnyPublisher()
        }
        
        let output = viewModel.transform(
            input: CertificationViewModel.Input(
                didCertificationNumberChanged: certificationFieldPublisher, didTouchedNextButton: nextButton.tapPublisher()
            )
        )
        
        output.nextButtonEnabled
            .sink { [weak self] value in
                self?.nextButton.isEnabled = value
            }
            .store(in: &bag)
    }
    
    func configureLayout() {
        guideLabelAndPhoneNumberStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        numStackView.snp.makeConstraints {
            $0.top.equalTo(guideLabelAndPhoneNumberStackView.snp.bottom).offset(81)
            $0.centerX.equalToSuperview()
        }
        
        certificationFieldClearTouchView.snp.makeConstraints {
            $0.edges.equalTo(numStackView)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(54)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configureView() {
        
        self.view.backgroundColor = .systemBackground
        
        var i = 0
        certificationFields.forEach {
            $0.certificationTextFieldDelegate = self
            $0.tag =  i
            i += 1
            $0.delegate = self
        }
    }
}

// MARK: - View Generators

private extension CertificationNumberViewController {
    
    func underLinedView(textField: UITextField) -> UIStackView {
        let stackView = UIStackView()
        let numTextField = textField
        let underBar = UIView()
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.alignment = .center
        numTextField.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        numTextField.textAlignment = .center
        underBar.widthAnchor.constraint(equalToConstant: 52).isActive = true
        underBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underBar.backgroundColor = .black
        stackView.addArrangedSubview(numTextField)
        stackView.addArrangedSubview(underBar)
        
        return stackView
    }
}

extension CertificationNumberViewController: UITextFieldDelegate, CertificationTextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidEnterBackspace(_ textField: CertificationTextField) {
        let index = textField.tag
        if index > 0 {
            certificationFields[index - 1].becomeFirstResponder()
            certificationFields[index - 1].text = ""
        } else {
            view.endEditing(true)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        if newString.count == 1 {
            textFieldShouldReturnSingle(textField, newString: newString)
        }
        
        return newString.count < 2
    }

    func textFieldShouldReturnSingle(_ textField: UITextField, newString: String) {
        let nextTag: Int = textField.tag + 1
        
        textField.text = newString
        if nextTag == certificationFields.count {
            textField.resignFirstResponder()
        }
        else {
            let nextResponder = certificationFields[nextTag]
            nextResponder.becomeFirstResponder()
        }
    }

}

#if DEBUG
import SwiftUI
struct CertificationNumberViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        CertificationNumberViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                CertificationNumberViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
