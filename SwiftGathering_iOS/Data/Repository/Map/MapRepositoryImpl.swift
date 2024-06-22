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
    private var stompHandler: STOMPHandler
    
    init(locationHandler: LocationHandler,stompHandler: STOMPHandler) {
        self.locationHandler = locationHandler
        self.stompHandler = stompHandler
    }
    
    func setup() {
        stompHandler.registerSockect()
        stompHandler.subscribe()
        locationHandler.start()
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return locationHandler.location
    }
    
    func broadcastMyLocation(_ myLocation: MyLocation) {
        do {
            let locationInput = MockLocationInput(senderId: 1212, channelId: "wow", latitude: myLocation.latitude, longitude: myLocation.longitude)
            try stompHandler.send(using: locationInput)
        } catch {
            
        }
    }
    
//    func fetchFriendsLocation() -> Observable<CLLocation> {
//        
//    }

    func listenToPrivateChannel() -> Observable<String> {
        return .just("d")
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

