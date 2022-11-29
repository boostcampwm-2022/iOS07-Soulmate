//
//  UISlider+Publisher.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/29.
//

import UIKit
import Combine

public extension UISlider {
    func valuePublisher() -> AnyPublisher<Float, Never> {
        return UIControl.ControlEvent(control: self, event: [.allEditingEvents, .valueChanged])
            .map { _ in
                self.value
            }
            .eraseToAnyPublisher()
    }
}
