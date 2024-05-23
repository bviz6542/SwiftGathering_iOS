//
//  LoginUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import RxSwift

protocol LoginUseCaseProtocol {
    func login(using loginInfo: LoginInfo) -> Observable<Void>
    func loginWithPreviousLoginInfo() -> Observable<Void>
}

class LoginUseCase: LoginUseCaseProtocol {
    private var loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
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
