//
//  LoginUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

protocol LoginUseCaseProtocol {
    func login(using loginInput: LoginInput) async -> Result<EmptyOutput, Error>
}

class LoginUseCase: LoginUseCaseProtocol {
    private var loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }

    func login(using loginInput: LoginInput) async -> Result<EmptyOutput, Error> {
        return await loginRepository.login(using: loginInput)
    }
}
