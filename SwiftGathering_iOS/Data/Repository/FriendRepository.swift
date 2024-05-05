//
//  FriendRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import Foundation
import RxSwift

protocol FriendRepositoryProtocol {
    func fetchMyInfo() -> Observable<MyInfo>
    func saveMyInfo(using myInfo: MyInfo) -> Observable<Void>
    func fetchFriends(using myInfo: MyInfo) -> Observable<[FriendInfo]>
}

class FriendRepository: FriendRepositoryProtocol {
    private var httpHandler: HTTPHandler
    private var userDefaults: UserDefaults
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
    }
    
    func fetchMyInfo() -> Observable<MyInfo> {
        guard let fetchedObject = userDefaults.data(forKey: "myInfo") else {
            return Observable.error(UserDefaultsError.doesNotExist)
        }
        guard let myInfo = try? JSONDecoder().decode(MyInfo.self, from: fetchedObject) else {
            return Observable.error(UserDefaultsError.decodeFailed)
        }
        return Observable.just(myInfo)
    }
    
    func saveMyInfo(using myInfo: MyInfo) -> Observable<Void> {
        guard let encodedObject = try? JSONEncoder().encode(myInfo) else {
            return Observable.error(UserDefaultsError.encodeFailed)
        }
        userDefaults.setValue(encodedObject, forKey: "myInfo")
        return Observable.just(())
    }
    
    func fetchFriends(using myInfo: MyInfo) -> Observable<[FriendInfo]> {
        let myID = myInfo.id
        return httpHandler
            .setPath(.friends(memberID: myID))
            .setPort(8080)
            .setMethod(.get)
            .rxSend(expecting: [FriendsOutput].self)
            .map { outputs in
                return outputs
                    .map { output in
                        FriendInfo(id: output.id)
                    }
            }
    }
}
