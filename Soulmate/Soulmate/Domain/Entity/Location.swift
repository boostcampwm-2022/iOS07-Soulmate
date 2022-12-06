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
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
    
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
}
