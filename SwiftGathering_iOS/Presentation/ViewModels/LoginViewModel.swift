//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import Combine

class LoginViewModel {
    var loginUseCase: LoginUseCase
    var loginResult = PassthroughSubject<Bool, Error>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(with loginInput: LoginInput) {
        Task {
            let result = await loginUseCase.execute(loginInput: loginInput)
            switch result {
            case .success(let success):
                self.loginResult.send(success)
            case .failure(let error):
                self.loginResult.send(completion: .failure(error))
            }
        }
    }
}
