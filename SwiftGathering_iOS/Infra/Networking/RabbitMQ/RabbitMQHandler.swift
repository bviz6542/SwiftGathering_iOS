//
//  RabbitMQHandler.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 4/4/24.
//

import RxSwift
import RMQClient

class RabbitMQHandler: NSObject {
    private var connection: RMQConnection?
    private var channel: RMQChannel?
    
    func initializeConnection(using clientId: String) -> (RMQExchange, RMQQueue) {
        let connection = RMQConnection(uri: "amqp://guest:guest@localhost", delegate: RMQConnectionDelegateLogger())
        connection.start()
        let channel = connection.createChannel()
        
        self.connection = connection
        self.channel = channel
        
        let exchange = channel.direct("swift-gathering.exchange", options: .durable)
        let queue = channel.queue("swift-gathering.queue.\(clientId)", options: .durable)
        queue.bind(exchange, routingKey: "swift-gathering.routing.\(clientId)")
        
        return (exchange, queue)
    }
    
    func send(to exchange: RMQExchange, request: Codable, using clientId: String) -> Observable<Void>  {
        return Observable.create { observer in
            do {
                let requestData = try JSONEncoder().encode(request)
                exchange.publish(requestData, routingKey: "swift-gathering.routing.\(clientId)", persistent: false)
                observer.onCompleted()
                
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func listen<T: Codable>(to queue: RMQQueue, expecting responseType: T.Type) -> Observable<T> {
        return Observable.create { observer in
            queue.subscribe(withAckMode: .manual) { message in
                do {
                    let response = try JSONDecoder().decode(responseType, from: message.body)
                    observer.onNext(response)
                    
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func listen(to queue: RMQQueue) -> Observable<String> {
        return Observable.create { observer in
            queue.subscribe(withAckMode: .manual) { message in
                do {
                    guard let response = String(bytes: message.body, encoding: .utf8) 
                    else { throw RabbitMQError.failedParsingResponse }
                    observer.onNext(response)
                    
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    deinit {
        disconnect()
    }
    
    private func disconnect() {
        channel?.close()
        connection?.close()
    }
}
