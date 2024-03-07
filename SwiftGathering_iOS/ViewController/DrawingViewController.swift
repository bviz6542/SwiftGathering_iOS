//
//  DrawingViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

class DrawingViewController: UIViewController {
    @IBOutlet weak var canvasView: CanvasView!
    
    private var webSocketManger: WebSocketManager?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        webSocketManger = WebSocketManager()
        webSocketManger?.delegate = self
        webSocketManger?.connect()
        canvasView.webSocketManager = self.webSocketManger
    }
}

extension DrawingViewController: WebSocketManagerDelegate {
    func onReceiveChatSuccess(_ textContent: String) {
        print(textContent)
    }
    
    func onReceiveDrawingSuccess(_ drawingInfo: DrawingInfoDTO) {
        DispatchQueue.main.async {
            switch drawingInfo.event {
            case "began":
                self.canvasView.startDrawing(from: drawingInfo)
            case "moved":
                self.canvasView.continueDrawing(from: drawingInfo)
            case "ended":
                self.canvasView.finishDrawing()
            default:
                print("Unknown drawing event received")
            }
        }
    }
    
    func onFailure() {
        DispatchQueue.main.async {
            //            self.opponentTextView.text = "오류가 일어났습니다."
        }
    }
    
    func onSendSuccess(_ textContent: String) {
        DispatchQueue.main.async {
            //            self.myTextView.text = textContent
        }
    }
}
