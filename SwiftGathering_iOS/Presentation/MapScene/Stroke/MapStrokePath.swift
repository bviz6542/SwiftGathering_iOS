//
//  MapStrokePath.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/20/24.
//

import UIKit
import MapKit

struct MapStrokePath {
    var coordinates: [CLLocationCoordinate2D] = []
    
    init(canvasStrokePath: CanvasStrokePath, mapView: MKMapView, targetView: UIView) {
        self.coordinates = canvasStrokePath.points
            .map { point in
                mapView.convert(point, toCoordinateFrom: targetView)
            }
    }
    
    init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }
}
