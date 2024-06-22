//
//  LoginRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift
import Foundation

class LoginRepositoryImpl: LoginRepository {
    private let httpHandler: HTTPHandler
    private let userDefaults: UserDefaults
    private let tokenHolder: TokenHolder
    private let memberIdHolder: MemberIdHolder
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults, tokenHolder: TokenHolder, memberIdHolder: MemberIdHolder) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
        self.tokenHolder = tokenHolder
        self.memberIdHolder = memberIdHolder
    }
    
    func login(using loginInfo: LoginInfo) -> Observable<Void> {
        let loginInput = LoginInput(loginId: loginInfo.loginId, loginPassword: loginInfo.loginPassword)
        return httpHandler
            .setPath(.login)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .rxSend(expecting: LoginOutput.self)
        
            .withUnretained(self)
            .flatMap { (owner, loginOutput) in
                owner.saveToken(using: loginOutput)
            }
            .withUnretained(self)
            .flatMap { (owner, loginOutput) in
                owner.saveMemberId(using: loginOutput)
            }
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.saveLoginInfo(using: loginInfo)
            }
    }
    
    private func saveToken(using loginOutput: LoginOutput) -> Observable<LoginOutput> {
        tokenHolder.token = loginOutput.token
        return .just(loginOutput)
    }
    
    private func saveMemberId(using loginOutput: LoginOutput) -> Observable<Void> {
        memberIdHolder.memberId = loginOutput.memberId
        return .just(())
    }
    
    private func saveLoginInfo(using loginInfo: LoginInfo) -> Observable<Void> {
        guard let encodedObject = try? JSONEncoder().encode(loginInfo) else { return .error(UserDefaultsError.encodeFailed) }
        userDefaults.setValue(encodedObject, forKey: "loginInfo")
        return .just(())
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
}
