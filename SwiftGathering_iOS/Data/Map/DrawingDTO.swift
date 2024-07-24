//
//  DrawingDTO.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/21/24.
//

import Foundation
import UIKit
import MapKit

struct DrawingDTO: Codable {
    var senderId: Int
    var channelId: String
    var state: StrokeState
    var path: StrokePath
    
    struct StrokeState: Codable {
        var color: String
        var width: Float
        var alpha: Float
        var blendMode: String
    }
    
    struct StrokePath: Codable {
        var coordinates: [Coordinate]
        
        struct Coordinate: Codable {
            var latitude: Double
            var longitude: Double
        }
    }
    
    init(mapStroke: MapStroke, senderId: Int, channelId: String) {
        self.senderId = senderId
        self.channelId = channelId
        let state = StrokeState(
            color: mapStroke.state.color.cgColor.toString(),
            width: Float(mapStroke.state.width),
            alpha: Float(mapStroke.state.alpha),
            blendMode: mapStroke.state.blendMode.toString()
        )
        self.state = state
        
        let coordinates = mapStroke.path.coordinates.map { coordinate in
            StrokePath.Coordinate(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
        path = StrokePath(coordinates: coordinates)
    }
    
    func toDomain() -> MapStroke {
        let state = MapStrokeState(
            color: UIColor(cgColor: state.color.toCGColor()),
            width: CGFloat(state.width),
            alpha: CGFloat(state.alpha),
            blendMode: CGBlendMode(state.blendMode)
        )
        
        let coordinates = path.coordinates.map { coordinate in
            CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        let path = MapStrokePath(coordinates: coordinates)
        
        return MapStroke(state: state, path: path)
    }
}
