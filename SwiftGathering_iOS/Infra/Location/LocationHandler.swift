//
//  LocationHandler.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 3/15/24.
//

import CoreLocation
import RxSwift
import RxCocoa

class LocationHandler: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let locationSubject = PublishSubject<CLLocation>()
    
    var location: Observable<CLLocation> {
        return locationSubject.asObservable()
    }
    
    func start() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationSubject.onNext(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.onError(error)
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

