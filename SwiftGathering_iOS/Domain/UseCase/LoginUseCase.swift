//
//  LoginUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import RxSwift

protocol LoginUseCaseProtocol {
    func login(using loginInfo: LoginInfo) -> Single<Void>
    func loginWithPreviousLoginInfo() -> Single<Void>
}

class LoginUseCase: LoginUseCaseProtocol {
    private var loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    func login(using loginInfo: LoginInfo) -> Single<Void> {
        loginRepository
            .login(using: loginInfo)
            .asObservable().withUnretained(self)
            .flatMap { (owner, _) in
                owner.loginRepository.saveLoginInfo(using: loginInfo)
            }.asSingle()
    }
    
    func loginWithPreviousLoginInfo() -> Single<Void> {
        loginRepository.fetchPreviousLoginInfo()
            .asObservable().withUnretained(self)
            .flatMap({ (owner, loginInfo) in
                owner.loginRepository.login(using: loginInfo)
                    .flatMap { .just(loginInfo) }
            })
            .withUnretained(self)
            .flatMap { (owner, loginInfo) in
                owner.loginRepository.saveLoginInfo(using: loginInfo)
            }
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.loginRepository.saveMyInfo(using: MyInfo(id: "1"))
            }.asSingle()
    }
}
