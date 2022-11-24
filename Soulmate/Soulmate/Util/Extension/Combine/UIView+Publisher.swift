//
//  UIView+Publisher.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/24.
//

import UIKit
import Combine

extension UIView {
    var tapPublisher: AnyPublisher<Void, Never> {
        return UIControl.ControlEvent(control: self as? UIControl ?? UIControl(), event: .touchUpInside)
            .eraseToAnyPublisher()
    }
}
