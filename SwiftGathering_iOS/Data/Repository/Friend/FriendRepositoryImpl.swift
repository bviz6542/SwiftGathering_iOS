//
//  FriendRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import Foundation

class FriendRepositoryImpl: FriendRepository {
    private var httpHandler: HTTPHandler
    private var userDefaults: UserDefaults
    private var tokenHolder: TokenHolder
    private var memberIdHolder: MemberIdHolder
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults, tokenHolder: TokenHolder, memberIdHolder: MemberIdHolder) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
        self.tokenHolder = tokenHolder
        self.memberIdHolder = memberIdHolder
    }
    
    func fetchMyInfo() -> Observable<MyInfo> {
        .just(MyInfo(id: memberIdHolder.memberId))
    }
    
    func fetchFriends(using myInfo: MyInfo) -> Observable<[FriendInfo]> {
        let myID = String(myInfo.id)
        return httpHandler
            .setPath(.friends(memberID: myID))
            .setPort(8080)
            .setMethod(.get)
            .addHeader(key: "Authorization", value: "Bearer \(tokenHolder.token)")
            .rxSend(expecting: [FriendsOutput].self)
            .map { outputs in
                return outputs
                    .map { output in
                        FriendInfo(id: output.id, name: output.name, isSelected: false)
                    }
            }
    }
}
