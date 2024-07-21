//
//  SmoothLineOverlayRenderer.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/20/24.
//

import UIKit
import MapKit

class SmoothLineOverlayRenderer: MKOverlayRenderer {
    override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let overlay = overlay as? SmoothLineOverlay else { return }
        
        let strokePath = overlay.stroke.path
        guard let path = createBezierPath(for: strokePath) else { return }
        
        let strokeState = overlay.stroke.state
        context.setLineWidth(strokeState.width / zoomScale)
        context.setStrokeColor(strokeState.color.cgColor)
        context.setBlendMode(strokeState.blendMode)
        context.addPath(path)
        context.strokePath()
    }
    
    private func createBezierPath(for strokePath: MapStrokePath) -> CGPath? {
        guard strokePath.coordinates.count > 1 else { return nil }
        
        let path = UIBezierPath()
        let points = strokePath.coordinates.map { point(for: MKMapPoint($0)) }
        
        path.move(to: points[0])
        
        for i in 1..<points.count {
            let midPoint = CGPoint(
                x: (points[i-1].x + points[i].x) / 2,
                y: (points[i-1].y + points[i].y) / 2
            )
            path.addQuadCurve(to: midPoint, controlPoint: points[i-1])
        }
        
        path.addLine(to: points.last!)
        
        return path.cgPath
    }
    
    override func point(for mapPoint: MKMapPoint) -> CGPoint {
        let mapRect = overlay.boundingMapRect
        return CGPoint(
            x: mapPoint.x - mapRect.origin.x,
            y: mapPoint.y - mapRect.origin.y
        )
    }
}
