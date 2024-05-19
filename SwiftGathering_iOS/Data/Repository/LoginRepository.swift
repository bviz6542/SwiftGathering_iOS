//
//  LoginRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/14/24.
//

import Foundation
import RxSwift

protocol LoginRepositoryProtocol {
    func login(using loginInfo: LoginInfo) -> Single<LoginOutput>
    func fetchPreviousLoginInfo() -> Single<LoginInfo>
    func saveLoginInfo(using loginInfo: LoginInfo) -> Single<Void>
    func saveMyInfo(using myInfo: MyInfo) -> Single<Void>
}

class LoginRepository: LoginRepositoryProtocol {
    private var httpHandler: HTTPHandler
    private var userDefaults: UserDefaults
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
    }
    
    func login(using loginInfo: LoginInfo) -> Single<LoginOutput> {
        let loginInput = LoginInput(loginId: loginInfo.loginId, loginPassword: loginInfo.loginPassword)
        return httpHandler
            .setPath(.login)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .rxSend(expecting: LoginOutput.self)
    }
    
    func fetchPreviousLoginInfo() -> Single<LoginInfo> {
        guard let fetchedObject = userDefaults.data(forKey: "loginInfo") else {
            return .error(UserDefaultsError.doesNotExist)
        }
        guard let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: fetchedObject) else {
            return .error(UserDefaultsError.decodeFailed)
        }
        return .just(loginInfo)
    }
    
    func saveLoginInfo(using loginInfo: LoginInfo) -> Single<Void> {
        guard let encodedObject = try? JSONEncoder().encode(loginInfo) else { return .error(UserDefaultsError.encodeFailed) }
        userDefaults.setValue(encodedObject, forKey: "loginInfo")
        return .just(())
    }
    
    func saveMyInfo(using myInfo: MyInfo) -> Single<Void> {
        guard let encodedObject = try? JSONEncoder().encode(myInfo) else { return .error(UserDefaultsError.encodeFailed) }
        userDefaults.setValue(encodedObject, forKey: "myInfo")
        return .just(())
    }
}
