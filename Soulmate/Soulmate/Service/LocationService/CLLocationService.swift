//
//  CLLocationService.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import Combine
import CoreLocation

class CLLocationService: NSObject, LocationService {

    var locationManager: CLLocationManager
    var locationSubject = PassthroughSubject<Location, Never>()
    var authSubject = PassthroughSubject<Bool, Never>()
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()

        self.configureService()
    }
    
    func configureService() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 2000
        locationManager.allowsBackgroundLocationUpdates = true
                
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

}

extension CLLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            guard let location = locations.last else { return }
            var locationInstance = Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            locationSubject.send(locationInstance)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .notDetermined, .denied:
            locationManager.requestAlwaysAuthorization()
        }
    }
}
