//
//  UITextField+Publisher.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/14.
//

import UIKit
import Combine

extension UITextField {
    func textPublisher() -> AnyPublisher<String?, Never> {
        return UIControl.ControlEvent(control: self, event: [.allEditingEvents, .valueChanged])
            .map { _ in
                return self.text
            }
            .eraseToAnyPublisher()
    }
}
