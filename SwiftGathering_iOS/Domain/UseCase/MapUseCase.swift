//
//  MapUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift

protocol MapUseCaseProtocol {
    func fetchFriendLocation() -> Observable<FriendLocation>
}

class MapUseCase: MapUseCaseProtocol {
    private var mapRepository: MapRepositoryProtocol
    
    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
    }
    
    func fetchFriendLocation() -> Observable<FriendLocation> {
        return mapRepository.fetchFriendLocation()
    }
    
    func sendMyLocation() {
        // TODO: send my location to server
    }
}
