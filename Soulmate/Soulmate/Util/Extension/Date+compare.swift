//
//  Date+distance.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/09.
//

import Foundation

extension Date {
    
    private func dayDistance(
        from date: Date) -> Int {
            
            var calendar = Calendar.current
            calendar.locale = .current
            let component: Calendar.Component = .day
            
            let date1 = calendar.component(component, from: self)
            let date2 = calendar.component(component, from: date)
            
            return date1 - date2
    }
    
    func compareByDay(with date: Date) -> Bool {
        dayDistance(from: date) == 0
    }
}
