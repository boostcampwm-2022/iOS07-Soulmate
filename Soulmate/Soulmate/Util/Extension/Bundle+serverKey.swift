//
//  Bundle.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

extension Bundle {
    var serverKey: String {
        
        guard let url = self.url(
            forResource: "PrivacyInfo",
            withExtension: "plist") else { return "" }
        
        guard let resource = try? NSDictionary(
            contentsOf: url,
            error: ()) else { return "" }
                    
        guard let key = resource["ServerKey"] as? String else { return "" }
        
        return key
    }
}
