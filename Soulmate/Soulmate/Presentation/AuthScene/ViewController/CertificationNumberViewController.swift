//
//  CertificationNumberViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit
import Combine

final class CertificationNumberViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: CertificationViewModel?
    var cancellables = Set<AnyCancellable>()
    var certificationNumberView: CertificationNumberView?

    // MARK: - Init
    
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
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        let view = CertificationNumberView(frame: self.view.frame)
        self.certificationNumberView = view
        self.view = view
    }
}

// MARK: - Private functions

private extension CertificationNumberViewController {
    func applyResponder() {
        guard let certificationNumberView = certificationNumberView else { return }
        
        for field in certificationNumberView.certificationFields {
            guard let text = field.text,
                  !text.isEmpty else {
                field.becomeFirstResponder()
                return
            }
        }
        
        guard let lastField = certificationNumberView.certificationFields.last else { return }
        lastField.becomeFirstResponder()
    }
}

// MARK: - Configure

private extension CertificationNumberViewController {
    
    func configure() {
        var i = 0
        certificationNumberView?.certificationFields.forEach {
            $0.certificationTextFieldDelegate = self
            $0.tag =  i
            i += 1
            $0.delegate = self
        }
    }
    
    func bind() {
        guard let viewModel = viewModel,
              let certificationNumberView = certificationNumberView else { return }

        certificationNumberView.userPhoneNumberLabel.text = viewModel.phoneNumber
        
        certificationNumberView.certificationFieldClearTouchView
            .tapPublisher()
            .sink { [weak self] in
                self?.applyResponder()
            }
            .store(in: &cancellables)
        
        var certificationFieldPublisher = certificationNumberView.certificationFields[0]
            .textPublisher()
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        for i in 1..<certificationNumberView.certificationFields.count {
            certificationFieldPublisher = certificationFieldPublisher
                .combineLatest(
                    certificationNumberView.certificationFields[i]
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
                didCertificationNumberChanged: certificationFieldPublisher,
                didTouchedNextButton: certificationNumberView.nextButton.tapPublisher()
            )
        )
        
        output.nextButtonEnabled
            .sink { [weak certificationNumberView] value in
                certificationNumberView?.nextButton.isEnabled = value
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - CertificationTextField Delegate

extension CertificationNumberViewController: UITextFieldDelegate, CertificationTextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldDidEnterBackspace(_ textField: CertificationTextField) {
        let index = textField.tag
        if index > 0 {
            certificationNumberView?.certificationFields[index - 1].becomeFirstResponder()
            certificationNumberView?.certificationFields[index - 1].text = ""
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
        if nextTag == certificationNumberView?.certificationFields.count {
            textField.resignFirstResponder()
        }
        else {
            let nextResponder = certificationNumberView?.certificationFields[nextTag]
            nextResponder?.becomeFirstResponder()
        }
    }

}
