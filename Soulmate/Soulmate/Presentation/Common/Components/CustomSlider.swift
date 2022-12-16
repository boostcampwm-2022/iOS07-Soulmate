//
//  CustomSlider.swift
//  Soulmate
//
//  Created by termblur on 2022/12/16.
//

import UIKit

final class CustomSlider: UISlider {
     override func trackRect(forBounds bounds: CGRect) -> CGRect {
          var result = super.trackRect(forBounds: bounds)
          result.origin.x = 0
          result.size.width = bounds.size.width
          result.size.height = 10
          return result
     }
    
    func thumbImage(radius: CGFloat) -> UIImage {
        lazy var thumbView: UIView = {
            let thumb = UIView()
            thumb.backgroundColor = .white
            thumb.layer.borderWidth = 0.4
            thumb.layer.borderColor = UIColor.labelGrey?.cgColor
            return thumb
        }()
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
  
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
}
