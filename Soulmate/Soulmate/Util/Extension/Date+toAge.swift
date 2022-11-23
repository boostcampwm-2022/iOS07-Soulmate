//
//  Date+toAge.swift
//  Soulmate
//
//  Created by termblur on 2022/11/24.
//

import Foundation

extension Date { // 만나이 계산기
    func toAge() -> Int {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}
