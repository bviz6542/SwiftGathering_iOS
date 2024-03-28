//
//  LoginInteractor.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

class LoginInteractor: LoginUseCase {
    func login(using loginInput: LoginInput) async -> Result<EmptyOutput, Error> {
        return await HTTPHandler()
            .setPath(.login)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(loginInput)
            .performNetworkOperation()
    }
}
