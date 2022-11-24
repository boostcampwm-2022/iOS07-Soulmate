//
//  CLLocationService.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import CoreLocation

class CLLocationService: NSObject {

    var locationManager: CLLocationManager
    let upLoadLocationUseCase: UpLoadLocationUseCase
    
    init(upLoadLocationUseCase: UpLoadLocationUseCase) {
        self.locationManager = CLLocationManager()
        self.upLoadLocationUseCase = upLoadLocationUseCase
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
            print(location)
            var locationInstance = Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            try await upLoadLocationUseCase.updateLocation(location: locationInstance)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined, .denied, .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        }
    }
}
