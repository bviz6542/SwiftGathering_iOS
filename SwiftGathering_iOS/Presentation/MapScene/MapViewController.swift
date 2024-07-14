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
    private var friendAnnotations = [Int: FriendAnnotation]()
    
    weak var coordinator: MapCoordinator?
    
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
        bindViewModel()
        mapViewModel.onViewDidLoad.onNext(())
    }
    
    private func bindViewModel() {
        mapViewModel.onFetchFriendLocation
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, location in
                    owner.updateFriendLocation(location)
                })
            .disposed(by: disposeBag)
        
        mapViewModel.onFetchMyLocation
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
        
        mapViewModel.onReceivedSessionRequest
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.present(AlertBuilder()
                    .setTitle("Start Gathering")
                    .setMessage("Would you like to start the gathering?")
                    .setCancelAction(title: "Cancel", style: .destructive)
                    .setProceedAction(title: "Confirm", style: .default, handler: { [weak self] _ in
                        self?.coordinator?.navigateToMapPage()
                        self?.mapViewModel.onConfirmStartGathering.onNext(message.sessionID)
                    })
                    .build(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setInitialRegion(using location: CLLocation) {
        updateMyLocation(to: location)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             span: MKCoordinateSpan(latitudeDelta: 0.001,
                                                                    longitudeDelta: 0.001
                                                                   )
                                            ),
                          animated: true)
    }
    
    private func setRegion(using location: CLLocation) {
        updateMyLocation(to: location)
    }
    
    private func updateMyLocation(to location: CLLocation) {
        let myLocationPin = MKPointAnnotation()
        myLocationPin.coordinate = location.coordinate
        myLocationPin.title = "My Location"
        mapView.removeAnnotations(mapView.annotations.filter { $0.title == "My Location" })
        mapView.addAnnotation(myLocationPin)
    }
    
    private func updateFriendLocation(_ locationInfo: FriendLocation) {
        let friendId = locationInfo.senderId
        if let existingPin = friendAnnotations[friendId] {
            existingPin.coordinate = CLLocationCoordinate2D(latitude: locationInfo.latitude, longitude: locationInfo.longitude)
        } else {
            let coordinate = CLLocationCoordinate2D(latitude: locationInfo.latitude, longitude: locationInfo.longitude)
            let annotation = FriendAnnotation(friendId: friendId, coordinate: coordinate)
            friendAnnotations[friendId] = annotation
            mapView.addAnnotation(annotation)
        }
    }
    
    private func color(for friendId: Int) -> UIColor {
        let colors: [UIColor] = [.green, .blue, .orange, .purple, .yellow]
        return colors[friendId % colors.count]
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let friendAnnotation = annotation as? FriendAnnotation {
            let identifier = FriendAnnotationView.identifier
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? FriendAnnotationView
            
            if annotationView == nil {
                annotationView = FriendAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView?.setTitle("Friend \(friendAnnotation.friendId)")
            annotationView?.setColor(color(for: friendAnnotation.friendId))
            
            return annotationView
        }
        
        return nil
    }
}
