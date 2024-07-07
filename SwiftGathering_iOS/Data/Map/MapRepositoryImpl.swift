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
    private var memberIdHolder: MemberIDHolder
    
    init(locationHandler: LocationHandler, stompHandler: STOMPHandler, memberIdHolder: MemberIDHolder) {
        self.locationHandler = locationHandler
        self.stompHandler = stompHandler
        self.memberIdHolder = memberIdHolder
    }
    
    func setup() {
        stompHandler.registerSocket()
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
            .compactMap { [weak self] jsonObject in
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
                   let message = try? JSONDecoder().decode(FriendLocationOutput.self, from: jsonData),
                   self?.memberIdHolder.memberId != message.senderId {
                    return message
                }
                return nil
            }
            .map{ $0.toDomain() }
    }
}
