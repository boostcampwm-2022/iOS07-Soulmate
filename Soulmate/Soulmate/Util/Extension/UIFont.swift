//
//  UIFont.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import UIKit

extension UIFont {
    
    func withWeight(_ weight: CGFloat) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = Weight(weight)
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
