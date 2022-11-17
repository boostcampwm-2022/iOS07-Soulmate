//
//  UIDatePicker+Publisher.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import UIKit
import Combine

extension UIDatePicker {
    func datePublisher() -> AnyPublisher<Date, Never> {
        return UIControl.ControlEvent(control: self, event: [.allEditingEvents, .valueChanged])
            .map { _ in
                return self.date
            }
            .eraseToAnyPublisher()
    }
}
