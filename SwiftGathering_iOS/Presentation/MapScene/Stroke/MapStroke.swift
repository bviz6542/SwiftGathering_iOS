//
//  MapStroke.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/20/24.
//

import UIKit
import MapKit

struct MapStroke {
    var state: MapStrokeState
    var path: MapStrokePath
    
    init(canvasStroke: CanvasStroke, mapView: MKMapView, targetView: UIView) {
        self.state = MapStrokeState(canvasStrokeState: canvasStroke.state)
        self.path = MapStrokePath(canvasStrokePath: canvasStroke.path, mapView: mapView, targetView: targetView)
    }
}
