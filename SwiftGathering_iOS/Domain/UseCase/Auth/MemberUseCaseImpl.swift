//
//  MemberUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift

class MemberUseCaseImpl: MemberUseCase {
    private var registerRepository: MemberRepository
    
    init(registerRepository: MemberRepository) {
        self.registerRepository = registerRepository
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        return await registerRepository.register(using: registerInfo)
    }
}
