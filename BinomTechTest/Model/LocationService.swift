//
//  LocationService.swift
//  BinomTechTest
//
//  Created by sergey on 22.08.2023.
//

import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    var location = CLLocation()
    var error: LocationError?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.delegate = self
    }
    
    func req() {
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .init(identifier: "RU")) { place, error in
            guard let location = place?.last?.location
            else {
                if let error = error as? NSError {
                    self.error = .error(error)
                } else {
                    self.error = .unkownPlace
                }
                return
            }
            self.location = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = .error(error as NSError)
    }
}

enum LocationError: LocalizedError {
    case error(NSError)
    case unkownPlace
    
    var errorDescription: String? {
        switch self {
        case .unkownPlace: return "Не удалось определить ваше текущее местоположение."
        case let .error(nserror): return nserror.localizedDescription
        }
    }
    
    var failureReason: String? {
        guard case let .error(nserror) = self else { return nil }
        return nserror.localizedFailureReason
    }
    var recoverySuggestion: String? {
        guard case let .error(nserror) = self else { return nil }
        return nserror.localizedRecoverySuggestion
    }
    var helpAnchor: String? {
        guard case let .error(nserror) = self else { return nil }
        return nserror.helpAnchor
    }
}
