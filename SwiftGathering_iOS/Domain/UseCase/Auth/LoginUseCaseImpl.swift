//
//  LoginUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift

class LoginUseCaseImpl: LoginUseCase {
    private var loginRepository: LoginRepository
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    func login(using loginInfo: LoginInfo) -> Observable<Void> {
        loginRepository
            .login(using: loginInfo)
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.loginRepository.saveLoginInfo(using: loginInfo)
            }
    }
    
    func loginWithPreviousLoginInfo() -> Observable<Void> {
        loginRepository.fetchPreviousLoginInfo()
            .withUnretained(self)
            .flatMap({ (owner, loginInfo) in
                owner.loginRepository.login(using: loginInfo)
                    .map { (loginInfo, $0) }
            })
            .withUnretained(self)
            .flatMap { (owner, infosToSave) in
                owner.loginRepository.saveLoginInfo(using: infosToSave.0)
                    .map { infosToSave.1 }
            }
            .withUnretained(self)
            .flatMap { (owner, loginOutput: LoginOutput) in
                owner.loginRepository.saveMyInfo(using: MyInfo(id: loginOutput.id))
            }
    }
}

