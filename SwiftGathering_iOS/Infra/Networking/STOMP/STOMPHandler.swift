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

    var result: Observable<AnyObject> {
        return resultSubject.asObservable()
    }
    
    func registerSockect() {
        let url = URL(string: "ws://localhost:8080/ws")!
        client.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self
        )
    }
    
    func subscribe() {
        client.subscribe(destination: "/topic/wow")
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
        registerSockect()
    }
    
    func serverDidSendPing() {}
}

extension StompClientLib {
    public func sendJSONForCodable(input: Codable, toDestination destination: String) {
        do {
            let jsonData = try JSONEncoder().encode(input)
            let theJSONText = String(data: jsonData, encoding: String.Encoding.utf8)!
            let header = ["content-type":"application/json;charset=UTF-8"]
            sendMessage(
                message: theJSONText,
                toDestination: destination,
                withHeaders: header,
                withReceipt: nil
            )
            
        } catch {
            print("error encoding JSON: \(error)")
        }
    }
}
