//
//  RegisterUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

protocol RegisterUseCaseProtocol {
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error>
}

class RegisterUseCase: RegisterUseCaseProtocol {
    private var registerRepository: RegisterRepository
    
    init(registerRepository: RegisterRepository) {
        self.registerRepository = registerRepository
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        return await registerRepository.register(using: registerInfo)
    }
}
