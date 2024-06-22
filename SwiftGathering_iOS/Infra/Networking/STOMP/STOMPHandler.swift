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
    private let friendsLocationSubject = PublishSubject<MockLocationInput>()

    var friendslocation: Observable<MockLocationInput> {
        return friendsLocationSubject.asObservable()
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
    
    func sendMessage() throws {
        if !client.isConnected() {
            throw STOMPError.notConnectedError
        }
        let locationInput = MockLocationInput(senderId: 1212, channelId: "wow", latitude: 33.0, longitude: 56.4)
        client.sendJSONForCodable(input: locationInput, toDestination: "/pub/location")
    }
    
    func disconnect() {
        client.disconnect()
    }
}

extension STOMPHandler: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("stompClient(")
        // friendsLocation.onNext
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
