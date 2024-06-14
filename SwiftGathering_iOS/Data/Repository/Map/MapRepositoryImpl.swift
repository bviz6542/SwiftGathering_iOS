//
//  MapRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import CoreLocation

class MapRepositoryImpl: MapRepository {
    private var locationHandler: LocationHandler
    private var privateRabbitMQHandler: RabbitMQHandler
    private var rabbitMQHandler: RabbitMQHandler
    
    init(
        locationHandler: LocationHandler,
        privateRabbitMQHandler: RabbitMQHandler,
        rabbitMQHandler: RabbitMQHandler
    ) {
        self.locationHandler = locationHandler
        self.privateRabbitMQHandler = privateRabbitMQHandler
        self.rabbitMQHandler = rabbitMQHandler
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return locationHandler.location
    }
    
//    func fetchFriendLocation() -> Observable<FriendLocationOutput> {
//        let (_, queue) = rabbitMQHandler.initializeConnection(using: "1")
//        return rabbitMQHandler.listen(to: queue, expecting: FriendLocationOutput.self)
//    }
    
    func listenToPrivateChannel() -> Observable<String> {
        let (_, queue) = privateRabbitMQHandler.initializeConnection(using: "1")
        return privateRabbitMQHandler.listen(to: queue)
    }
}

