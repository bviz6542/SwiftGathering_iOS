//
//  MapViewController.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 3/15/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)),animated: true)
                self.mapView.addAnnotation(pin)
                
            }
        }
    }
}
