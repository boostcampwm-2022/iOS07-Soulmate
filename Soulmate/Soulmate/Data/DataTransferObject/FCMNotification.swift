//
//  FCMNotification.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/13.
//

import Foundation

struct FCMNotification: Codable {
    private var title: String
    private var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
