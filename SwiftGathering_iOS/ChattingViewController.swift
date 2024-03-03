//
//  ChattingViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

class ChattingViewController: UIViewController {
    @IBOutlet weak var opponentTextView: UITextView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    private var webSocketManger: WebSocketManager?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        webSocketManger = WebSocketManager()
//        webSocketManger?.delegate = self
        webSocketManger?.connect()
    }
    
    @IBAction func onTouchedSendButton(_ sender: UIButton) {
        if let textContent = textField.text {
            webSocketManger?.send(textContent)
        }
    }
}

//extension ChattingViewController: WebSocketManagerDelegate {
//    func onFailure() {
//        DispatchQueue.main.async {
//            self.opponentTextView.text = "오류가 일어났습니다."
//        }
//    }
//    
//    func onSendSuccess(_ textContent: String) {
//        DispatchQueue.main.async {
//            self.myTextView.text = textContent
//        }
//    }
//    
//    func onReceiveChatSuccess(_ textContent: String) {
//        DispatchQueue.main.async {
//            self.opponentTextView.text = textContent
//        }
//    }
//}
