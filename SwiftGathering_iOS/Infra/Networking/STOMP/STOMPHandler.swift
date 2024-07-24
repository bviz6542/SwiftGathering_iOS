//
//  STOMPHandler.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 6/22/24.
//

import StompClientLib
import RxSwift

class STOMPHandler {
    private let client = StompClientLib()
    let resultSubject = PublishSubject<AnyObject>()
    
    var sessionID: String?
    
    func registerSocket() {
        let url = NSURL(string: "ws://192.168.219.125:8080/ws")!
        client.openSocketWithURLRequest(
            request: NSURLRequest(url: url as URL),
            delegate: self
        )
    }
    
    private func subscribe() {
        guard let sessionID = sessionID else { return }
        client.subscribe(destination: STOMPPath.sessionChannel(sessionID: sessionID).stringValue)
    }
    
    func send<T: Codable>(to path: STOMPPath, using input: T) throws {
        if !client.isConnected() {
            throw STOMPError.notConnectedError
        }
        client.sendJSONForCodable(input: input, toDestination: path.stringValue)
    }
    
    func disconnect() {
        client.disconnect()
    }
}

extension STOMPHandler: StompClientLibDelegate {
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
