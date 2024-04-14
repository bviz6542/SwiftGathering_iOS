//
//  LoginRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/14/24.
//

protocol LoginRepositoryProtocol {
    func login(using loginInput: LoginInput) async -> Result<EmptyOutput, Error>
}

class LoginRepository: LoginRepositoryProtocol {
    private var httpHandler: HTTPHandler
    
    init(httpHandler: HTTPHandler) {
        self.httpHandler = httpHandler
    }
    
    func login(using loginInput: LoginInput) async -> Result<EmptyOutput, any Error> {
        return await httpHandler
            .setPath(.login)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .performNetworkOperation()
    }
}
