//
//  CanvasView.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/20/24.
//

import UIKit
import RxSwift
import RxCocoa

class CanvasView: UIView {
    private var currentPath = UIBezierPath()
    private(set) var event = PublishRelay<CanvasViewEvent>()
    var strokeState = CanvasStrokeState()
    private var strokePath = CanvasStrokePath()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let startPoint = touch.location(in: self)
        currentPath = UIBezierPath()
        currentPath.move(to: startPoint)
        strokePath = CanvasStrokePath(points: [startPoint])
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        strokePath.points.append(currentPoint)
        drawBezierPath()
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let endPoint = touch.location(in: self)
        strokePath.points.append(endPoint)
        drawBezierPath()
        setNeedsDisplay()
        self.event.accept(.onDraw(CanvasStroke(state: strokeState, path: strokePath)))
        strokePath.points = []
        currentPath = UIBezierPath()
        setNeedsDisplay()
    }

    private func drawBezierPath() {
        guard strokePath.points.count > 1 else { return }
        currentPath.removeAllPoints()
        currentPath.move(to: strokePath.points[0])
        
        for i in 1 ..< strokePath.points.count {
            let midPoint = CGPoint(
                x: (strokePath.points[i-1].x + strokePath.points[i].x) / 2,
                y: (strokePath.points[i-1].y + strokePath.points[i].y) / 2
            )
            currentPath.addQuadCurve(to: midPoint, controlPoint: strokePath.points[i-1])
        }
        currentPath.addLine(to: strokePath.points.last!)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setBlendMode(strokeState.blendMode)
        context.setAlpha(strokeState.alpha)
        strokeState.color.setStroke()
        currentPath.lineWidth = strokeState.width
        currentPath.stroke()
    }
}
