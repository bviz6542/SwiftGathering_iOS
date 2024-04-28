//
//  MapRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift

protocol MapRepositoryProtocol {
    func sendMyLocation()
    func fetchFriendLocation() -> Observable<FriendLocation>
}

class MapRepository: MapRepositoryProtocol {
    private var rabbitMQHandler: RabbitMQHandler
    
    init(rabbitMQHandler: RabbitMQHandler) {
        self.rabbitMQHandler = rabbitMQHandler
    }
    
    func sendMyLocation() {
        // TODO: send my location to server
    }
    
    func fetchFriendLocation() -> Observable<FriendLocation> {
        return rabbitMQHandler.listen(expecting: FriendLocation.self)
    }
}
