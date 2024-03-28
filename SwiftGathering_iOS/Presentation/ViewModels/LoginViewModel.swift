//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import Combine

class LoginViewModel {
    var loginUseCase: LoginUseCase
    var loginResult = PassthroughSubject<Void, Error>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(using loginInput: LoginInput) {
        Task {
            await loginUseCase.login(using: loginInput)
                .onFailure { error in
                    loginResult.send(completion: .failure(error))
                }
                .onSuccess { _ in
                    loginResult.send()
                }
        }
    }
}
