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
                self?.setRegion(using: location)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func setRegion(using location: CLLocation) {
        DispatchQueue.main.async { [weak self] in
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            self?.mapView.addAnnotation(pin)
            self?.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)),animated: true)
        }
    }
}