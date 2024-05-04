//
//  MapViewController.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 3/15/24.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let disposeBag = DisposeBag()
    
    private var mapViewModel: MapViewModel
    
    private var isInitialLocationUpdate: Bool = true
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        mapViewModel
            .friendLocation
            .subscribe(onNext: { [weak self] location in
                let newLocation = CLLocation(latitude: location.latitude,
                                             longitude: location.longtitude)
                print(newLocation)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        mapViewModel
            .myLocation
            .subscribe(onNext: { [weak self] location in
                if self?.isInitialLocationUpdate == true {
                    self?.setInitialRegion(using: location)
                    self?.isInitialLocationUpdate = false
                } else {
                    self?.setRegion(using: location)
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setInitialRegion(using location: CLLocation) {
        DispatchQueue.main.async { [weak self] in
            guard let mapView = self?.mapView else { return }
            self?.updateMyLocation(to: location, in: mapView)
            let currentSpan = mapView.region.span
            mapView.setRegion(
                MKCoordinateRegion(center: location.coordinate,
                                   span: MKCoordinateSpan(latitudeDelta: 0.001,
                                                          longitudeDelta: 0.001)
                                  ),
                animated: true)
        }
    }
    
    private func setRegion(using location: CLLocation) {
        DispatchQueue.main.async { [weak self] in
            guard let mapView = self?.mapView else { return }
            self?.updateMyLocation(to: location, in: mapView)
        }
    }
    
    private func updateMyLocation(to location: CLLocation, in mapView: MKMapView) {
        let previousPins = mapView.annotations
        let updatedPin = MKPointAnnotation()
        updatedPin.coordinate = location.coordinate
        mapView.addAnnotation(updatedPin)
        mapView.removeAnnotations(previousPins)
    }
}
