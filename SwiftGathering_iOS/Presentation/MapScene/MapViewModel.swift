//
//  MapViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift

class MapViewModel {
    var userLocation: Observable<FriendLocation> {
        return mapUseCase.fetchFriendLocation()
//        return Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
    }
    
    private var mapUseCase: MapUseCaseProtocol
    
    init(mapUseCase: MapUseCase) {
        self.mapUseCase = mapUseCase
    }
}
