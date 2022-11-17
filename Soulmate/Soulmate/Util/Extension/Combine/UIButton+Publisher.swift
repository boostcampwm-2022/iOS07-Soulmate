//
//  UIButton.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/14.
//

import UIKit
import Combine

extension UIButton {
    func tapPublisher() -> AnyPublisher<Void, Never> {
        return UIControl.ControlEvent(control: self, event: .touchUpInside)
            .eraseToAnyPublisher()
    }
}
