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
        connection = RMQConnection(delegate: RMQConnectionDelegateLogger())
        connection?.start()
        channel = connection?.createChannel()
    }
    
    func listen<T: Codable>(expecting responseType: T.Type) -> Observable<T> {
        return Observable.create { [weak self] observer in
            guard let channel = self?.channel else {
                observer.onError(RabbitMQError.channelDoesNotExist)
                return Disposables.create()
            }
            let queue = channel.queue("swift-gathering")
            queue.subscribe { message in
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
    
    func send(request: Codable) -> Observable<Void>  {
        return Observable.create { [weak self] observer in
            do {
                guard let channel = self?.channel else { throw RabbitMQError.channelDoesNotExist }
                let requestData = try JSONEncoder().encode(request)
                let queue = channel.queue("swift-gathering")
                channel.defaultExchange().publish(requestData, routingKey: queue.name, persistent: true)
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
