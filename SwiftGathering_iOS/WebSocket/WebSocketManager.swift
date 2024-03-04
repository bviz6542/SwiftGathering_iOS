//
//  WebSocketManager.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import Foundation

class WebSocketManager {
    var webSocketTask: URLSessionWebSocketTask?
    var delegate: WebSocketManagerDelegate?
    
    func connect() {
        guard let url = URL(string: "ws://localhost:8081/helloo") else { return }
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        listenForMessages()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.onFailure()
                
            case .success(let message):
                switch message {
                case .data(let data):
                    do {
                        let result = try JSONDecoder().decode(DrawingInfoDTO.self, from: data)
                        self?.delegate?.onReceiveDrawingSuccess(result)
                        
                    } catch {
                        
                    }
                default:
                    break
                }
                
                self?.listenForMessages()
            }
        }
    }
    
    func send(_ textContent: String) {
        let message = URLSessionWebSocketTask.Message.string(textContent)
        webSocketTask?.send(message) { [weak self] error in
            if error != nil { self?.delegate?.onFailure() }
            else { self?.delegate?.onSendSuccess(textContent) }
        }
    }
    
    func sendDrawing(fullWidth: CGFloat, fullHeight: CGFloat, x: CGFloat, y: CGFloat) {
        do {
            let absolutePosition = ["fullWidth": fullWidth, "fullHeight": fullHeight, "x": x, "y": y]
            let jsonData = try JSONEncoder().encode(absolutePosition)
            let message = URLSessionWebSocketTask.Message.data(jsonData)
            webSocketTask?.send(message) { [weak self] error in
                if error != nil { self?.delegate?.onFailure() }
            }
            
        } catch {
            delegate?.onFailure()
        }
    }
}

protocol WebSocketManagerDelegate {
    func onFailure()
    func onSendSuccess(_ textContent: String)
    func onReceiveDrawingSuccess(_ drawingInfo: DrawingInfoDTO)
}
