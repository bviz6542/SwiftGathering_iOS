//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import Combine

class LoginViewModel {
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func login(using loginInfo: LoginInfo) async -> Result<Void, Error> {
        return await loginUseCase.login(using: loginInfo)
    }
}
