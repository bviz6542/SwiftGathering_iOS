//
//  FriendRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import Foundation
import RxSwift

protocol FriendRepositoryProtocol {
    func fetchMyInfo() -> Single<MyInfo>
    func saveMyInfo(using myInfo: MyInfo) -> Single<Void>
    func fetchFriends(using myInfo: MyInfo) -> Single<[FriendInfo]>
}

class FriendRepository: FriendRepositoryProtocol {
    private var httpHandler: HTTPHandler
    private var userDefaults: UserDefaults
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
    }
    
    func fetchMyInfo() -> Single<MyInfo> {
        guard let fetchedObject = userDefaults.data(forKey: "myInfo") else {
            return .error(UserDefaultsError.doesNotExist)
        }
        guard let myInfo = try? JSONDecoder().decode(MyInfo.self, from: fetchedObject) else {
            return .error(UserDefaultsError.decodeFailed)
        }
        return .just(myInfo)
    }
    
    func saveMyInfo(using myInfo: MyInfo) -> Single<Void> {
        guard let encodedObject = try? JSONEncoder().encode(myInfo) else {
            return .error(UserDefaultsError.encodeFailed)
        }
        userDefaults.setValue(encodedObject, forKey: "myInfo")
        return .just(())
    }
    
    func fetchFriends(using myInfo: MyInfo) -> Single<[FriendInfo]> {
        let myID = String(myInfo.id)
        return httpHandler
            .setPath(.friends(memberID: myID))
            .setPort(8080)
            .setMethod(.get)
            .rxSend(expecting: [FriendsOutput].self)
            .map { outputs in
                return outputs
                    .map { output in
                        FriendInfo(id: output.id, name: output.name)
                    }
            }
    }
}
