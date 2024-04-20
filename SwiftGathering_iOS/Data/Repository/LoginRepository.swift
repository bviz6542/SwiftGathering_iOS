//
//  LoginRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/14/24.
//

import Foundation

protocol LoginRepositoryProtocol {
    func login(using loginInfo: LoginInfo) async -> Result<Void, Error>
    func fetchPreviousLoginInfo() -> Result<LoginInfo, Error>
    func saveLoginInfo(using loginInfo: LoginInfo) -> Result<Void, Error>
}

class LoginRepository: LoginRepositoryProtocol {
    private var httpHandler: HTTPHandler
    private var userDefaults: UserDefaults
    
    init(httpHandler: HTTPHandler, userDefaults: UserDefaults) {
        self.httpHandler = httpHandler
        self.userDefaults = userDefaults
    }
    
    func login(using loginInfo: LoginInfo) async -> Result<Void, Error> {
        let loginInput = LoginInput(id: loginInfo.loginID, password: loginInfo.loginPassword)
        return await httpHandler
            .setPath(.login)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .send(expecting: EmptyOutput.self)
            .eraseToVoid()
    }
    
    func fetchPreviousLoginInfo() -> Result<LoginInfo, Error> {
        guard let fetchedObject = userDefaults.data(forKey: "loginInfo") else {
            return .failure(UserDefaultsError.doesNotExist)
        }
        guard let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: fetchedObject) else {
            return .failure(UserDefaultsError.decodeFailed)
        }
        return .success(loginInfo)
    }
    
    func saveLoginInfo(using loginInfo: LoginInfo) -> Result<Void, Error> {
        guard let encodedObject = try? JSONEncoder().encode(loginInfo) else { return .failure(UserDefaultsError.encodeFailed) }
        userDefaults.setValue(encodedObject, forKey: "loginInfo")
        return .success(())
    }
}
