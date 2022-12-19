//
//  UserDefaults+Publisher.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation

extension UserDefaults {
    
    @objc dynamic var distance: Double {
        return double(forKey: "distance")
    }
    
    @objc dynamic var latestLocation: Data? {
        return data(forKey: "latestLocation")
    }
    
    @objc dynamic var token: String? {
        return string(forKey: UserDefaultKey.fcmToken)
    }
}
