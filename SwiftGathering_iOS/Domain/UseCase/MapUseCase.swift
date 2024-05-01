//
//  MapUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

protocol MapUseCaseProtocol {
    func fetchMyLocation() -> Observable<CLLocation>
    func fetchFriendLocation() -> Observable<FriendLocationOutput>
}

class MapUseCase: MapUseCaseProtocol {
    private var mapRepository: MapRepositoryProtocol
    
    init(mapRepository: MapRepositoryProtocol) {
        self.mapRepository = mapRepository
    }
    
    func fetchMyLocation() -> Observable<CLLocation> {
        return mapRepository.fetchMyLocation()
    }
    
    func fetchFriendLocation() -> Observable<FriendLocationOutput> {
        return mapRepository.fetchFriendLocation()
    }
}
