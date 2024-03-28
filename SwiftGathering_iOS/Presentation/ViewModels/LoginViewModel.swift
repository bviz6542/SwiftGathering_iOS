//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import Combine

class LoginViewModel {
    var loginUseCase: LoginUseCase
    @Published var loginResult: Bool = false
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(using loginInput: LoginInput) {
        Task {
            await loginUseCase.login(using: loginInput)
                .onFailure { error in
                    return loginResult
                    loginResult.send(completion: .failure(error))
                }
                .onSuccess { _ in
                    loginResult.send()
                }
        }
    }
}
