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
    private let resultSubject = PublishSubject<AnyObject>()
    
    var sessionID: String?

    var result: Observable<AnyObject> {
        return resultSubject.asObservable()
    }
    
    func registerSocket() {
        let url = URL(string: "ws://localhost:8080/ws")!
        client.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self
        )
    }
    
    private func subscribe() {
        guard let sessionID = sessionID else { return }
        client.subscribe(destination: "/topic/\(sessionID)")
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
