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
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
    }
    
    func fetchMyInfo() -> Observable<MyInfo> {
        guard let fetchedObject = userDefaults.data(forKey: "myInfo") else {
            return .error(UserDefaultsError.doesNotExist)
        }
        guard let myInfo = try? JSONDecoder().decode(MyInfo.self, from: fetchedObject) else {
            return .error(UserDefaultsError.decodeFailed)
        }
        return .just(myInfo)
    }
    
    func saveMyInfo(using myInfo: MyInfo) -> Observable<Void> {
        guard let encodedObject = try? JSONEncoder().encode(myInfo) else {
            return .error(UserDefaultsError.encodeFailed)
        }
        userDefaults.setValue(encodedObject, forKey: "myInfo")
        return .just(())
    }
    
    func fetchFriends(using myInfo: MyInfo) -> Observable<[FriendInfo]> {
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
