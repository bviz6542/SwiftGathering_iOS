//
//  MapUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import CoreLocation

class MapUseCaseImpl: MapUseCase {
    private var mapRepository: MapRepository
    
    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return mapRepository.fetchMyLocation()
    }
    
//    func fetchFriendLocation() -> Observable<FriendLocationOutput> {
//        return mapRepository.fetchFriendLocation()
//    }
    
    func listenToPrivateChannel() -> Observable<String> {
        return mapRepository.listenToPrivateChannel()
    }
}

