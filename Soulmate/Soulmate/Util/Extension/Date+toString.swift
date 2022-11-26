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
        let nowMonth = Calendar.current.dateComponents([.month], from: now).month
        let nowDay = Calendar.current.dateComponents([.day], from: now).day
        let nowHour = Calendar.current.dateComponents([.hour], from: now).hour
        let nowMinute = Calendar.current.dateComponents([.minute], from: now).minute
        
        let messageYear = Calendar.current.dateComponents([.year], from: self).year
        let messageMonth = Calendar.current.dateComponents([.month], from: self).month
        let messageDay = Calendar.current.dateComponents([.day], from: self).day
        let messageHour = Calendar.current.dateComponents([.hour], from: self).hour
        let messageMinute = Calendar.current.dateComponents([.minute], from: self).minute
        
        let passedDay = nowDay! - messageDay!
        
        if passedDay > 0 {
            if passedDay > 365 {
                return passedWeeks(Int(ceil(Double(passedDay / 365))))
            }
            
            if passedDay > 30 {
                return passedWeeks(Int(ceil(Double(passedDay / 30))))
            }
            
            if passedDay > 7 {
                return passedWeeks(Int(ceil(Double(passedDay / 7))))
            }
            
            return passedDays(passedDay)
            
        } else if nowDay! == messageDay! {
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
    
    private func passedDays(_ days: Int) -> String {
        return "\(days)일"
    }
    
    private func passedWeeks(_ weeks: Int) -> String {
        return "\(weeks)주"
    }
    
    private func passedMonths(_ months: Int) -> String {
        return "\(months)주"
    }
    
    private func passedYears(_ years: Int) -> String {
        return "\(years)주"
    }
}
