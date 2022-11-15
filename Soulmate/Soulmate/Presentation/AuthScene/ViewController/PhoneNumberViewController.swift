//
//  PhoneNumberViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit
import SnapKit
import Combine

final class PhoneNumberViewController: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    var viewModel: PhoneNumberViewModel?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님의 휴대폰번호를\n입력해주세요"
        label.numberOfLines = 2
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        self.view.addSubview(label)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "본인의 휴대폰 번호를 입력해주세요."
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        self.view.addSubview(label)
        return label
    }()
    private lazy var nationCodeDropDown: UITextField = {
        let textField = UITextField()
        textField.placeholder = "US +1"
        textField.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(textField)
        return textField
    }()
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "01012345678"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.delegate = self
        textField.keyboardType = .numberPad
        self.view.addSubview(textField)
        return textField
    }()
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        button.isEnabled = false
        self.view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    convenience init(viewModel: PhoneNumberViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.addUnderLine()
        nationCodeDropDown.addUnderLine()
    }
}

// MARK: - View Generators

private extension PhoneNumberViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: PhoneNumberViewModel.Input(
                didChangedNationCode: nationCodeDropDown.textPublisher(),
                didChangedPhoneNumber: phoneNumberTextField.textPublisher(),
                didTouchedNextButton: nextButton.tapPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .sink { [weak self] value in
                self?.nextButton.isEnabled = value
            }
            .store(in: &bag)
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        
        configurePickerView()
    }
    
    func configureLayout() {

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalTo(titleLabel.snp.left)
        }
        nationCodeDropDown.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(86)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(86)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            $0.width.equalTo(216)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(54)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}

extension PhoneNumberViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension PhoneNumberViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalPhonePrefix.allCases.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GlobalPhonePrefix.allCases[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nationCodeDropDown.text = row != 0 ? GlobalPhonePrefix.allCases[row].rawValue : ""
    }
    
    func configurePickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        nationCodeDropDown.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.didFinishedPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        nationCodeDropDown.inputAccessoryView = toolBar
    }
    
    @objc func didFinishedPicker() {
        view.endEditing(true)
    }
    
}

enum GlobalPhonePrefix: String, CaseIterable {
    case mock = "국가 선택"
    case korea = "+82"
    case japen = "+81"
    case usa = "+1"
}

extension UITextField {
    func addUnderLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height + 3, width: self.bounds.width, height: 2.5)
        bottomLine.backgroundColor = UIColor.systemGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
