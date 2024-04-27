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
    
    private var currentLocation = CLLocation()
    private let disposeBag = DisposeBag()
    
    private var mapViewModel: MapViewModel
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("this view controller is not initialized via nib")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.getUserLocation { [weak self] location in
            self?.currentLocation = location
            self?.setRegion(using: location)
        }
        
        bind()
    }
    
    private func bind() {
        mapViewModel
            .userLocation
            .subscribe { [weak self] event in
                DispatchQueue.main.async {
                    guard let currentLocation = self?.currentLocation else { return }
                    let randomX = Double(currentLocation.coordinate.latitude) + Double(Int.random(in: 1 ..< 10)%10)
                    let randomY = Double(currentLocation.coordinate.longitude) + Double(Int.random(in: 1 ..< 10)%10)
                    
                    let newLocation = CLLocation(latitude: randomX, longitude: randomY)
                    self?.currentLocation = newLocation
                    print(newLocation)
                    
                    self?.setRegion(using: newLocation)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setRegion(using location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)),animated: true)
        self.mapView.addAnnotation(pin)
    }
}
