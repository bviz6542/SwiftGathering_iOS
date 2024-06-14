//
//  RegisterUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift

class RegisterUseCaseImpl: RegisterUseCase {
    private var registerRepository: RegisterRepository
    
    init(registerRepository: RegisterRepository) {
        self.registerRepository = registerRepository
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        return await registerRepository.register(using: registerInfo)
    }
}
