//
//  FriendUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift

class FriendUseCaseImpl: FriendUseCase {
    private var friendRepository: FriendRepository
    
    init(friendRepository: FriendRepository) {
        self.friendRepository = friendRepository
    }
    
    func fetchFriends() -> Observable<[FriendInfo]> {
        friendRepository.fetchMyInfo()
            .withUnretained(self)
            .flatMap { owner, myInfo in
                owner.friendRepository.fetchFriends(using: myInfo)
            }
    }
}
