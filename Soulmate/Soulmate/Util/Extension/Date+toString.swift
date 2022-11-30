//
//  Date+toString.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import Foundation

extension Date {
    
    func passedTime() -> String {
        let now = Date.now
        let nowYear = Calendar.current.dateComponents([.year], from: now).year
        let nowDay = Calendar.current.dateComponents([.day], from: now).day

        let messageYear = Calendar.current.dateComponents([.year], from: self).year
        let messageDay = Calendar.current.dateComponents([.day], from: self).day
        
        if nowYear! > messageYear! {
            return self.yyyyMMdd()
        }
        
        if nowDay! - messageDay! > 0 {
            return self.Md()
        }
        
        if nowDay! == messageDay! {
            return self.aHmm()
        }
        
        return ""
    }
    
    func aHmm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a H:mm"
        
        return dateFormatter.string(from: self)
    }
    
    private func Md() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일"
        
        return dateFormatter.string(from: self)
    }
    
    func yyyyMMdd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: self)
    }
}
