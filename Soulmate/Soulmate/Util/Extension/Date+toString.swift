//
//  Date+toString.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import Foundation

extension Date {
    func aHmm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a H:mm"
        
        return dateFormatter.string(from: self)
    }
}
