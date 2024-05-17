//
//  RabbitMQHandler.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 4/4/24.
//

import RxSwift
import RMQClient

class RabbitMQHandler {
    private var connection: RMQConnection?
    private var channel: RMQChannel?
    
    init() {
        initializeConnection()
    }
    
    private func initializeConnection() {
        connection = RMQConnection(uri: "amqp://guest:guest@localhost", delegate: RMQConnectionDelegateLogger())
        connection?.start()
        channel = connection?.createChannel()
        
        if let channel = channel {
            let exchange = channel.direct("swift-gathering.exchange")
            let queue = channel.queue("swift-gathering.queue", options: .durable)
            queue.bind(exchange, routingKey: "swift-gathering.routing")
        }
    }
    
    func listen<T: Codable>(expecting responseType: T.Type) -> Observable<T> {
        return Observable.create { [weak self] observer in
            guard let channel = self?.channel else {
                observer.onError(RabbitMQError.channelDoesNotExist)
                return Disposables.create()
            }
            let queue = channel.queue("swift-gathering.queue", options: .durable)
            queue.subscribe(withAckMode: .manual) { message in
                do {
                    print("received message: \(String(describing: String(bytes: message.body, encoding: .utf8)))")
                    let response = try JSONDecoder().decode(responseType, from: message.body)
                    observer.onNext(response)
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func send(request: Codable) -> Observable<Void>  {
        return Observable.create { [weak self] observer in
            do {
                guard let channel = self?.channel else { throw RabbitMQError.channelDoesNotExist }
                let requestData = try JSONEncoder().encode(request)
                let exchange = channel.direct("swift-gathering.exchange")
                exchange.publish(requestData, routingKey: "swift-gathering.routing", persistent: true)
                observer.onNext(())
                observer.onCompleted()
                
            } catch {
                observer.onError(error)
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
