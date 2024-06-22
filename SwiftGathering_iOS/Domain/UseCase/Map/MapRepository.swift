//
//  MapRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

protocol MapRepository {
    func fetchMyLocation() -> Observable<CLLocation>
//    func fetchFriendLocation() -> Observable<FriendLocationOutput>
    func listenToPrivateChannel() -> Observable<String>
}