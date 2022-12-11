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
    
    func address() async throws -> String? {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let placeMark = try await CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "Ko-kr"))
        guard let place = placeMark.first,
              let locality = place.locality,
              let subLocality = place.subLocality else { return nil }
        
        return "\(locality) \(subLocality)"
    }
    
    static func distance(from: Location, to: Location) -> Double {
        let fromCL = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toCL = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return toCL.distance(from: fromCL) * 0.001
    }
}
