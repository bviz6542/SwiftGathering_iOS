//
//  SplashViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/20/24.
//

class SplashViewModel {
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func loginWithPreviousLoginInfo() async -> Result<Void, Error> {
        return await loginUseCase.loginWithPreviousLoginInfo()
    }
}
