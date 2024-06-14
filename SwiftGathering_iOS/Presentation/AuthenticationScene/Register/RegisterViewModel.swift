//
//  RegisterViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

class RegisterViewModel {
    private var registerUseCase: RegisterUseCase
    
    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        return await registerUseCase.register(using: registerInfo)
    }
}
