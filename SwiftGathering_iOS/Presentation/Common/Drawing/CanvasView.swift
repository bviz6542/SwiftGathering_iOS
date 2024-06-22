//
//  CanvasView.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

class CanvasView: UIView {
    
    var mode: DrawingMode = .pen
    var drawnLines: [DrawingPathInfo] = []
    var drawingLine: DrawingPathInfo?
    
    var lineColor: CGColor = UIColor.black.cgColor
    var lineWidth: CGFloat = 10
    
    private var points = [CGPoint]()
    var savedImage: UIImage?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        savedImage?.draw(in: self.bounds)
        
        if let drawingLine = drawingLine {
            context.addPath(drawingLine.path.cgPath)
            switch drawingLine.mode {
            case .pen: context.setBlendMode(.normal)
            case .eraser: context.setBlendMode(.clear)
            case .highlighter: context.setAlpha(0.3)
            }
            context.setStrokeColor(lineColor)
            context.setLineWidth(lineWidth)
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        
        points = [touchPoint]
        drawingLine = DrawingPathInfo(mode: mode, color: lineColor, width: lineWidth)
        drawingLine?.path.move(to: touchPoint)
        
        sendDrawingData(touchPoint: touchPoint, event: "began")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        
        points.append(touchPoint)
        
        if points.count == 2 {
            drawingLine?.path.addLine(to: touchPoint)
            
        } else if points.count > 2 {
            drawingLine?.path.removeAllPoints()
            drawingLine?.path.move(to: points.first!)
            
            for i in 1 ..< points.count - 1 {
                let nextIndex = i + 1
                let endPoint = CGPoint(x: (points[i].x + points[nextIndex].x)/2, y: (points[i].y + points[nextIndex].y)/2)
                drawingLine?.path.addQuadCurve(to: endPoint, controlPoint: points[i])
            }
        }
        setNeedsDisplay()
        sendDrawingData(touchPoint: touchPoint, event: "moved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if points.count == 1, let touchPoint = touches.first?.location(in: self) {
            drawingLine?.path.addLine(to: touchPoint)
        }
        
        if let drawingLine = drawingLine {
            drawnLines.append(drawingLine)
            self.drawingLine = nil
        }
        
        convertPathsToImage()
        points.removeAll()
        sendDrawingData(touchPoint: CGPoint.zero, event: "ended") // Using CGPoint.zero to indicate end
    }
    
    func convertPathsToImage() {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: format)
        let image = renderer.image { context in
            drawnLines.forEach { line in
                context.cgContext.addPath(line.path.cgPath)
                switch line.mode {
                case .pen: context.cgContext.setBlendMode(.normal)
                case .eraser: context.cgContext.setBlendMode(.clear)
                case .highlighter: context.cgContext.setAlpha(0.3)
                }
                context.cgContext.setStrokeColor(line.color)
                context.cgContext.setLineWidth(line.width)
                context.cgContext.setLineCap(.round)
                context.cgContext.setLineJoin(.round)
                context.cgContext.strokePath()
            }
        }
        savedImage = image
        setNeedsDisplay()
    }
    
    func clearDrawing() {
        drawnLines.removeAll()
        savedImage = nil
        setNeedsDisplay()
    }
    
    func sendDrawingData(touchPoint: CGPoint, event: String) {
        let normalizedPoint = CGPoint(x: touchPoint.x / bounds.width, y: touchPoint.y / bounds.height)
        let drawingInfo = DrawingInfoDTO(fullWidth: bounds.width, fullHeight: bounds.height, x: normalizedPoint.x, y: normalizedPoint.y, event: event) // Assume DrawingInfoDTO now includes an 'event' property
        
        // Serialize and send the drawing info
        do {
            let data = try JSONEncoder().encode(drawingInfo)
//            webSocketManager?.sendDrawing(fullWidth: drawingInfo.fullWidth, fullHeight: drawingInfo.fullHeight, x: drawingInfo.x, y: drawingInfo.y, event: drawingInfo.event)
        } catch {
            print("Error encoding drawing data: \(error)")
        }
    }
    
    // Add to CanvasView

    func startDrawing(from dto: DrawingInfoDTO) {
        let point = CGPoint(x: dto.x * bounds.width, y: dto.y * bounds.height)
        points = [point]
        drawingLine = DrawingPathInfo(mode: mode, color: lineColor, width: lineWidth)
        drawingLine?.path.move(to: point)
        setNeedsDisplay()
    }

    func continueDrawing(from dto: DrawingInfoDTO) {
        let point = CGPoint(x: dto.x * bounds.width, y: dto.y * bounds.height)
        guard let drawingLine = drawingLine else { return }
        points.append(point)

        if points.count == 2 {
            drawingLine.path.addLine(to: point)
        } else if points.count > 2 {
            drawingLine.path.removeAllPoints()
            drawingLine.path.move(to: points.first!)
            for i in 1 ..< points.count - 1 {
                let nextIndex = i + 1
                let endPoint = CGPoint(x: (points[i].x + points[nextIndex].x)/2, y: (points[i].y + points[nextIndex].y)/2)
                drawingLine.path.addQuadCurve(to: endPoint, controlPoint: points[i])
            }
        }
        setNeedsDisplay()
    }

    func finishDrawing() {
        if let drawingLine = drawingLine {
            drawnLines.append(drawingLine)
            self.drawingLine = nil
            convertPathsToImage()
        }
        points.removeAll()
    }
}
