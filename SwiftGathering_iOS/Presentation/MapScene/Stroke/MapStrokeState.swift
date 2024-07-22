//
//  MapStrokeState.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/20/24.
//

import UIKit

struct MapStrokeState {
    var color: UIColor = .blue
    var width: CGFloat = 2.0
    var alpha: CGFloat = 1.0
    var blendMode: CGBlendMode = .normal
    
    init(canvasStrokeState: CanvasStrokeState) {
        self.color = canvasStrokeState.color
        self.width = canvasStrokeState.width
        self.alpha = canvasStrokeState.alpha
        self.blendMode = canvasStrokeState.blendMode
    }
    
    init(color: UIColor, width: CGFloat, alpha: CGFloat, blendMode: CGBlendMode) {
        self.color = color
        self.width = width
        self.alpha = alpha
        self.blendMode = blendMode
    }
}
