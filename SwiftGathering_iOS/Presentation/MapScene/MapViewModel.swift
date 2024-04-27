//
//  MapViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift

class MapViewModel {
    var userLocation: Observable<Int> {
        return Observable<Int>
            .timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
    }
    
    private var mapUseCase: MapUseCase
    
    init(mapUseCase: MapUseCase) {
        self.mapUseCase = mapUseCase
    }
    
    func fetchFriendLocation() {
        
    }
}
