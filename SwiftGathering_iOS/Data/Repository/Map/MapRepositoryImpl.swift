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
    private var memberIdHolder: MemberIdHolder
    
    init(locationHandler: LocationHandler,stompHandler: STOMPHandler, memberIdHolder: MemberIdHolder) {
        self.locationHandler = locationHandler
        self.stompHandler = stompHandler
        self.memberIdHolder = memberIdHolder
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
            let memberId = memberIdHolder.memberId
            let locationInput = MockLocationInput(senderId: memberId, channelId: "wow", latitude: myLocation.latitude, longitude: myLocation.longitude)
            try stompHandler.send(using: locationInput)
        } catch {
            
        }
    }
    
    func fetchFriendLocation() -> Observable<FriendLocation> {
        stompHandler
            .result
            .compactMap { jsonObject in
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
                   let message = try? JSONDecoder().decode(FriendLocationOutput.self, from: jsonData) {
                    return message
                }
                return nil
            }
            .map{ $0.toDomain() }
    }

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

