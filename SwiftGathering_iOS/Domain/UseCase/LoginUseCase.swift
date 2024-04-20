//
//  LoginUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

protocol LoginUseCaseProtocol {
    func login(using loginInfo: LoginInfo) async -> Result<Void, Error>
    func loginWithPreviousLoginInfo() async -> Result<Void, Error>
}

class LoginUseCase: LoginUseCaseProtocol {
    private var loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }

    func login(using loginInfo: LoginInfo) async -> Result<Void, Error> {
        return await loginRepository.login(using: loginInfo)
            .flatMap { _ in
                return loginRepository.saveLoginInfo(using: loginInfo)
            }
    }
    
    func loginWithPreviousLoginInfo() async -> Result<Void, Error> {
        guard let loginInfo = loginRepository.fetchPreviousLoginInfo().getOrNil() else { return .failure(LoginError.loginInfoSearchFailed) }
        return await loginRepository.login(using: loginInfo)
            .flatMap { _ in
                return loginRepository.saveLoginInfo(using: loginInfo)
            }
    }
}
