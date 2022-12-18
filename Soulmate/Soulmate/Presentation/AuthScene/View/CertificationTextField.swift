//
//  CertificationTextField.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import UIKit

class CertificationTextField: UITextField {
    weak var certificationTextFieldDelegate: CertificationTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        configureView()
    }
    
    override func deleteBackward() {
        if text?.isEmpty ?? false {
            certificationTextFieldDelegate?.textFieldDidEnterBackspace(self)
        }
        
        super.deleteBackward()
    }
    
    func configureView() {
        self.keyboardType = .numberPad
    }
}

protocol CertificationTextFieldDelegate: AnyObject {
    func textFieldDidEnterBackspace(_ textField: CertificationTextField)
}
