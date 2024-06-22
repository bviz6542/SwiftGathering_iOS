//
//  MapRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import CoreLocation

class MapRepositoryImpl: MapRepository {
    func listenToPrivateChannel() -> RxSwift.Observable<String> {
        .just("d")
    }
    
    private var locationHandler: LocationHandler
    
    init(
        locationHandler: LocationHandler
    ) {
        self.locationHandler = locationHandler
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return locationHandler.location
    }
    
//    func fetchFriendLocation() -> Observable<FriendLocationOutput> {
//        let (_, queue) = rabbitMQHandler.initializeConnection(using: "1")
//        return rabbitMQHandler.listen(to: queue, expecting: FriendLocationOutput.self)
//    }
//    
//    func listenToPrivateChannel() -> Observable<String> {
//        let (_, queue) = privateRabbitMQHandler.initializeConnection(using: "1")
//        return privateRabbitMQHandler.listen(to: queue)
//    }
}

