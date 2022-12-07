//
//  Location.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}

extension Location {
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
    
    func toDistance(from: CLLocation) -> CLLocationDistance {
        let toPoint = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return toPoint.distance(from: from)
    }
    
    static func distance(from: Location, to: Location) -> Double {
        let fromCL = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toCL = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return toCL.distance(from: fromCL)
    }
}
