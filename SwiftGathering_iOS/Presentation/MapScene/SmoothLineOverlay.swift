//
//  SmoothLineOverlay.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/20/24.
//

import MapKit

class SmoothLineOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    var stroke: MapStroke
    
    init(stroke: MapStroke) {
        self.stroke = stroke
        self.coordinate = stroke.path.coordinates.first ?? CLLocationCoordinate2D()
        self.boundingMapRect = stroke.path.coordinates
            .map { MKMapPoint($0) }
            .map { MKMapRect(origin: $0, size: MKMapSize(width: 0, height: 0)) }
            .reduce(MKMapRect.null) { $0.union($1) }
    }
    
    func boundingRegion() -> MKCoordinateRegion {
        let coordinates = stroke.path.coordinates
        var minLat = coordinates.first?.latitude ?? 0
        var maxLat = coordinates.first?.latitude ?? 0
        var minLon = coordinates.first?.longitude ?? 0
        var maxLon = coordinates.first?.longitude ?? 0
        
        for coord in coordinates {
            if coord.latitude < minLat { minLat = coord.latitude }
            if coord.latitude > maxLat { maxLat = coord.latitude }
            if coord.longitude < minLon { minLon = coord.longitude }
            if coord.longitude > maxLon { maxLon = coord.longitude }
        }
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.2, longitudeDelta: (maxLon - minLon) * 1.2)
        return MKCoordinateRegion(center: center, span: span)
    }
}
