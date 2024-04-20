//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import Combine

class LoginViewModel {
    private var loginUseCase: LoginUseCaseProtocol
    var loginResult = PassthroughSubject<Void, Error>()
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func login(using loginInput: LoginInput) {
//        Task {
//            await loginUseCase.login(using: loginInput)
//                .onFailure { error in
//                    loginResult.send(completion: .failure(error))
//                }
//                .onSuccess { _ in
//                    loginResult.send()
//                }
//        }
    }
}
