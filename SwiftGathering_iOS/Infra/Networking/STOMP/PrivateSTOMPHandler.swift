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
        let url = URL(string: "ws://[2001:e60:106c:d26e:8df:7b47:c81f:b5e4]/ws")!
        client.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self
        )
    }
    
    private func subscribe() {
        guard let myID = myID else { return }
        client.subscribe(destination: "/topic/\(myID)")
    }
    
    func send<T: Codable>(using input: T) throws {
        if !client.isConnected() {
            throw STOMPError.notConnectedError
        }
        client.sendJSONForCodable(input: input, toDestination: "/pub/location")
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
