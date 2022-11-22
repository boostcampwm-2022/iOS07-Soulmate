//
//  UIImage.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/21.
//

import UIKit

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
