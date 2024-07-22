//
//  MapUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

protocol MapUseCase {
    func setup(with sessionID: String)
    func fetchMyLocation() -> Observable<CLLocation>
    func broadcastMyLocation(_ myLocation: MyLocation)    
    func fetchFriendLocation() -> Observable<FriendLocation>
    func createGathering(with guestIDs: [Int]) -> Observable<CreatedSessionIdOutput>
    func broadcastMyDrawing(_ drawing: MapStroke)
    func fetchFriendDrawing() -> Observable<MapStroke>
}
