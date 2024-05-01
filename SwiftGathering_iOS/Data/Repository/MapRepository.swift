//
//  MapRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

protocol MapRepositoryProtocol {
    func fetchMyLocation() -> Observable<CLLocation>
    func fetchFriendLocation() -> Observable<FriendLocationOutput>
}

class MapRepository: MapRepositoryProtocol {
    private var locationHandler: LocationHandler
    private var rabbitMQHandler: RabbitMQHandler
    
    init(locationHandler: LocationHandler, rabbitMQHandler: RabbitMQHandler) {
        self.locationHandler = locationHandler
        self.rabbitMQHandler = rabbitMQHandler
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return locationHandler.location
    }
    
    func fetchFriendLocation() -> Observable<FriendLocationOutput> {
        return rabbitMQHandler.listen(expecting: FriendLocationOutput.self)
    }
}
