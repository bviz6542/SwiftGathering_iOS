//
//  PrivateSTOMPHandler.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import StompClientLib
import RxSwift

class PrivateSTOMPHandler {
    var myID: Int?
    
    private let client = StompClientLib()
    let resultSubject = PublishSubject<AnyObject>()
    
    func registerSocket() {
        let url = URL(string: "ws://localhost/ws")!
        client.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self
        )
    }
    
    private func subscribe() {
        guard let myID = myID else { return }
        client.subscribe(destination: "/topic/private/\(myID)")
    }
    
    func disconnect() {
        client.disconnect()
    }
}

extension PrivateSTOMPHandler: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        if let jsonBody = jsonBody {
            resultSubject.onNext(jsonBody)
        }
    }
    
    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {}
    
    func stompClientDidDisconnect(client: StompClientLib!) {}
    
    func stompClientDidConnect(client: StompClientLib!) {
        subscribe()
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {}
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        client.disconnect()
        registerSocket()
    }
    
    func serverDidSendPing() {}
}
