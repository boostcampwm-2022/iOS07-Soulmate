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
    
    // MARK: - Properties
    
    var bag = Set<AnyCancellable>()
    var viewModel: PhoneNumberViewModel?
    var phoneNumberView: PhoneNumberView?
    
    // MARK: - Init
    
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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    override func loadView() {
        super.loadView()
        
        let view = PhoneNumberView(frame: self.view.frame)
        self.phoneNumberView = view
        self.view = view
    }
    override func viewDidLayoutSubviews() {
        phoneNumberView?.phoneNumberTextField.addUnderLine()
        phoneNumberView?.nationCodeDropDown.addUnderLine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            viewModel?.actions?.quitPhoneLoginFlow?()
        }
    }
}

// MARK: - Configure

private extension PhoneNumberViewController {
    
    func configure() {
        phoneNumberView?.phoneNumberTextField.delegate = self
        configurePickerView()
    }
    
    func bind() {
        guard let viewModel = viewModel,
              let phoneNumberView = phoneNumberView else { return }
        
        let output = viewModel.transform(
            input: PhoneNumberViewModel.Input(
                didChangedNationCode: phoneNumberView.nationCodeDropDown.textPublisher(),
                didChangedPhoneNumber: phoneNumberView.phoneNumberTextField.textPublisher(),
                didTouchedNextButton: phoneNumberView.nextButton.tapPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .sink { [weak phoneNumberView] value in
                phoneNumberView?.nextButton.isEnabled = value
            }
            .store(in: &bag)
    }

}

// MARK: - UITextFieldDelegate

extension PhoneNumberViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UIPickerView

extension PhoneNumberViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NationCode.allCases.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NationCode.allCases[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        phoneNumberView?.nationCodeDropDown.text = row != 0 ? NationCode.allCases[row].rawValue : ""
    }
    
    func configurePickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        phoneNumberView?.nationCodeDropDown.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.didFinishedPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        phoneNumberView?.nationCodeDropDown.inputAccessoryView = toolBar
    }
    
    @objc func didFinishedPicker() {
        view.endEditing(true)
    }
}
