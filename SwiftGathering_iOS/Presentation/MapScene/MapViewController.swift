//
//  MapViewController.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 3/15/24.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var widthButtonContainerView: UIView!
    @IBOutlet weak var colorPickerButtonContainerView: UIView!
    @IBOutlet weak var colorPickerButtonColorView: UIView!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var drawingModeButton: UIButton!
    
    private var isInitialLocationUpdate: Bool = true
    private var friendAnnotations = [Int: FriendAnnotation]()
    private var isDrawingMode = false
    
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
        setColorPickerButtonColor()
        mapView.delegate = self
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
        
        mapViewModel.onStartGathering
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.activateGathering()
            })
            .disposed(by: disposeBag)
        
        mapViewModel.onEndGathering
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.deactivateGathering()
            })
            .disposed(by: disposeBag)
        
        drawingModeButton.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.toggleDrawingMode()
            })
            .disposed(by: disposeBag)
        
        colorPickerButton.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] in
                self?.showColorPicker()
            })
            .disposed(by: disposeBag)
        
        canvasView.event
            .asSignal()
            .emit(onNext: { [weak self] event in
                switch event {
                case .onDraw(let canvasStroke): self?.addStrokeToMap(canvasStroke)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func activateGathering() {
        canvasView.isHidden = true
        drawingModeButton.isHidden = false
        colorPickerButtonContainerView.isHidden = false
        widthButtonContainerView.isHidden = false
    }
    
    private func deactivateGathering() {
        canvasView.isHidden = true
        drawingModeButton.isHidden = true
        colorPickerButtonContainerView.isHidden = true
        widthButtonContainerView.isHidden = true
    }
    
    private func toggleDrawingMode() {
        isDrawingMode.toggle()
        if isDrawingMode {
            drawingModeButton.setImage(UIImage(systemName: "pencil.tip.crop.circle.fill"), for: .normal)
            canvasView.isHidden = false
            mapView.isUserInteractionEnabled = false
            
        } else {
            drawingModeButton.setImage(UIImage(systemName: "pencil.tip.crop.circle"), for: .normal)
            canvasView.isHidden = true
            mapView.isUserInteractionEnabled = true
        }
    }
    
    func addStrokeToMap(_ canvasStroke: CanvasStroke) {
        let overlay = SmoothLineOverlay(
            stroke: MapStroke(canvasStroke: canvasStroke, mapView: mapView, targetView: canvasView)
        )
        mapView.removeOverlay(overlay)
        mapView.addOverlay(overlay)
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
    
    private func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = canvasView.strokeState.color
        present(colorPicker, animated: true, completion: nil)
    }
    
    private func setColorPickerButtonColor() {
        colorPickerButtonColorView.backgroundColor = canvasView.strokeState.color
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is SmoothLineOverlay {
            return SmoothLineOverlayRenderer(overlay: overlay)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MapViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        canvasView.strokeState.color = viewController.selectedColor
        setColorPickerButtonColor()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        canvasView.strokeState.color = viewController.selectedColor
        setColorPickerButtonColor()
    }
}
