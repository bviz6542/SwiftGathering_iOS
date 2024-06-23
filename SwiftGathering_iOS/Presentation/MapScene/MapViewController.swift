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
    
    private var isInitialLocationUpdate: Bool = true
    private var friendAnnotations = [Int: MKPointAnnotation]()
    
    private var mapViewModel: MapViewModel
    private let disposeBag = DisposeBag()
    
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
            .friendLocationOutput
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, location in
                    owner.setRegion(using: CLLocation(latitude: location.latitude, longitude: location.longitude))
                })
            .disposed(by: disposeBag)
        
        mapViewModel
            .myLocationOutput
            .observe(on: MainScheduler.instance)
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
        
        mapViewModel.privateChannelInput.onNext(())
        
        mapViewModel
            .privateChannelOutput
            .subscribe(
                with: self,
                onNext: { _, message in
                    print(message)
                }, onError: { _, error in
                    print(error)
                })
            .disposed(by: disposeBag)
        
        mapViewModel.myLocationInitiateInput.onNext(())
    }
    
    private func setInitialRegion(using location: CLLocation) {
        guard let mapView = mapView else { return }
        updateMyLocation(to: location, in: mapView)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             span: MKCoordinateSpan(latitudeDelta: 0.001,
                                                                    longitudeDelta: 0.001
                                                                   )
                                            ),
                          animated: true)
    }
    
    private func setRegion(using location: CLLocation) {
        guard let mapView = mapView else { return }
        updateMyLocation(to: location, in: mapView)
    }
    
    private func updateMyLocation(to location: CLLocation, in mapView: MKMapView) {
        let myLocationPin = MKPointAnnotation()
        myLocationPin.coordinate = location.coordinate
        myLocationPin.title = "My Location"
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == "My Location" })
        mapView.addAnnotation(myLocationPin)
    }
    
    private func updateFriendLocation(_ location: FriendLocationOutput) {
        guard let mapView = mapView else { return }
        let friendId = location.senderId
        
        let friendPin: MKPointAnnotation
        if let existingPin = friendAnnotations[friendId] {
            friendPin = existingPin
            friendPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            friendPin = MKPointAnnotation()
            friendPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            friendPin.title = "Friend \(friendId)"
            friendAnnotations[friendId] = friendPin
            mapView.addAnnotation(friendPin)
        }
    }
    
    private func color(for friendId: Int) -> UIColor {
        let colors: [UIColor] = [.red, .green, .blue, .orange, .purple, .yellow]
        return colors[friendId % colors.count]
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let title = annotation.title, title == "My Location" || title?.contains("Friend") == true else {
            return nil
        }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let title = annotation.title, title?.contains("Friend") == true, let friendId = Int(title!.split(separator: " ")[1]) {
            annotationView?.pinTintColor = color(for: friendId)
        } else {
            annotationView?.pinTintColor = .black
        }
        
        return annotationView
    }
}
