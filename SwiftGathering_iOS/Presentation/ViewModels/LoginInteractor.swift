//
//  LoginInteractor.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

class LoginInteractor: LoginUseCase {
//    func execute(loginInput: LoginInput) async {
//    let _ :Result<EmptyOutput, Error> = await HTTPHandler()
//            .setPath(.login)
//            .setPort(8080)
//            .setMethod(.post)
//            .setRequestBody(loginInput)
//            .performNetworkOperation()
//    }
    func execute(loginInput: LoginInput) async -> Result<Bool, Error> {
        // Mocked network call to login
        await Task.sleep(1_000_000_000) // Simulates network delay
        return .success(true) // Simulate successful login
    }
}
