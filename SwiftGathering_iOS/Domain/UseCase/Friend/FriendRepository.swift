//
//  FriendRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift

protocol FriendRepository {
    func fetchMyInfo() -> Observable<MyInfo>
    func saveMyInfo(using myInfo: MyInfo) -> Observable<Void>
    func fetchFriends(using myInfo: MyInfo) -> Observable<[FriendInfo]>
}
