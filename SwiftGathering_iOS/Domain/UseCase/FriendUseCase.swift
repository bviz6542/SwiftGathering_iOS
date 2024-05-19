//
//  FriendUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift

protocol FriendUseCaseProtocol {
    func fetchFriends() -> Single<[FriendInfo]>
}

class FriendUseCase: FriendUseCaseProtocol {
    private var friendRepository: FriendRepositoryProtocol
    
    init(friendRepository: FriendRepositoryProtocol) {
        self.friendRepository = friendRepository
    }
    
    func fetchFriends() -> Single<[FriendInfo]> {
        friendRepository.fetchMyInfo()
            .asObservable().withUnretained(self)
            .flatMap { owner, myInfo in
                owner.friendRepository.fetchFriends(using: myInfo)
            }
            .asSingle()
    }
}
