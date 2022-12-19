//
//  UITextField.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import UIKit

extension UITextField {
    func addUnderLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height + 8, width: self.bounds.width, height: 2.5)
        bottomLine.backgroundColor = UIColor.underlineGrey?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
