//
//  FriendUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift

protocol FriendUseCase {
    func fetchFriends() -> Observable<[FriendInfo]>
}
