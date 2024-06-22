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
        return loginRepository.login(using: loginInfo)
    }
    
    func loginWithPreviousLoginInfo() -> Observable<Void> {
        loginRepository
            .fetchPreviousLoginInfo()
            .withUnretained(self)
            .flatMap({ (owner, loginInfo) in
                owner.loginRepository.login(using: loginInfo)
            })
    }
}

