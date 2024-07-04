//
//  LocationManager.swift
//  MyTrips
//
//  Created by Anton Shvets on 30.06.2024.
//

import Foundation
import CoreLocation

@Observable
final class LocationManager: NSObject, ObservableObject {
    
    @ObservationIgnored private var manager = CLLocationManager()
    
    var userLocation: CLLocation?
    var isAuthorized: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            isAuthorized = true
            manager.startUpdatingLocation()
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
