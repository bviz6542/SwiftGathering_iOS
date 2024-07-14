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
    
    func setup(with sessionID: Int) {
        mapRepository.setup(with: sessionID)
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        mapRepository.fetchMyLocation()
    }
    
    func broadcastMyLocation(_ myLocation: MyLocation) {
        mapRepository.broadcastMyLocation(myLocation)
    }
    
    func fetchFriendLocation() -> Observable<FriendLocation> {
        mapRepository.fetchFriendLocation()
    }
    
    func createGathering(with guestIDs: [Int]) -> Observable<Void> {
        mapRepository.createGathering(with: guestIDs)
    }
}

