//
//  LoginRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import Foundation

class LoginRepositoryImpl: LoginRepository {
    private var httpHandler: HTTPHandler
    private var userDefaults: UserDefaults
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
    }
    
    func login(using loginInfo: LoginInfo) -> Observable<LoginOutput> {
        let loginInput = LoginInput(username: loginInfo.loginId, password: loginInfo.loginPassword)
        return httpHandler
            .setPath(.login)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .rxSend(expecting: LoginOutput.self)
    }
    
    func fetchPreviousLoginInfo() -> Observable<LoginInfo> {
        guard let fetchedObject = userDefaults.data(forKey: "loginInfo") else {
            return .error(UserDefaultsError.doesNotExist)
        }
        guard let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: fetchedObject) else {
            return .error(UserDefaultsError.decodeFailed)
        }
        return .just(loginInfo)
    }
    
    func saveLoginInfo(using loginInfo: LoginInfo) -> Observable<Void> {
        guard let encodedObject = try? JSONEncoder().encode(loginInfo) else { return .error(UserDefaultsError.encodeFailed) }
        userDefaults.setValue(encodedObject, forKey: "loginInfo")
        return .just(())
    }
    
//    func saveMyInfo(using myInfo: MyInfo) -> Observable<Void> {
//        guard let encodedObject = try? JSONEncoder().encode(myInfo) else { return .error(UserDefaultsError.encodeFailed) }
//        userDefaults.setValue(encodedObject, forKey: "myInfo")
//        return .just(())
//    }
    
    func saveToken(using loginOutput: LoginOutput) -> Observable<Void> {
        TokenHolder.shared.token = loginOutput.token
        return .just(())
    }
}
