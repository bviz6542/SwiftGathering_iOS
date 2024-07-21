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
    var sessionIDOutput = PublishSubject<CreatedSessionIdOutput>()
    
    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
    }
    
    func setup(with sessionID: String) {
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
    
    func createGathering(with guestIDs: [Int]) -> Observable<CreatedSessionIdOutput> {
        let observableOutput = mapRepository.createGathering(with: guestIDs).debug()
        print("ho")
        _ = observableOutput.map { [weak self] output in
            self?.sessionIDOutput.onNext(output)
        }
        return observableOutput
    }
    
    func broadcastMyDrawing(_ drawing: DrawingInfoDTO) {
        mapRepository.broadcastMyDrawing(drawing)
    }
    
    func fetchFriendDrawing() -> Observable<DrawingInfoDTO> {
        mapRepository.fetchFriendDrawing()
    }
}

