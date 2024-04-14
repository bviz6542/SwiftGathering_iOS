//
//  RabbitMQHandler.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 4/4/24.
//

import RMQClient

class RabbitMQHandler {
    private var channel: RMQChannel?
    weak var delegate: RabbitMQHandlerDelegate?
    
    func initialize() {
        let connection = RMQConnection(delegate: RMQConnectionDelegateLogger())
        connection.start()
        channel = connection.createChannel()
    }
    
    func listen(expecting responseType: Codable.Type) throws {
        guard let channel = channel else { throw RabbitMQError.channelDoesNotExist }
        let queue = channel.queue("swift-gathering")
        queue.subscribe { [weak self] message in
            if let response = try? JSONDecoder().decode(responseType.self, from: message.body) {
                self?.delegate?.onReceive(response: response)
            }
        }
    }
    
    func send(request: Codable) throws  {
        guard let channel = channel else { throw RabbitMQError.channelDoesNotExist }
        let requestData = try JSONEncoder().encode(request)
        let queue = channel.queue("swift-gathering")
        channel.defaultExchange().publish(requestData, routingKey: queue.name, persistent: true)
    }
    
    func disconnect() {
        channel?.close()
        channel = nil
    }
}

protocol RabbitMQHandlerDelegate: AnyObject {
    func onReceive(response: Codable)
}
