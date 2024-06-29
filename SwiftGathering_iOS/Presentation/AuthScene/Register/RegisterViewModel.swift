//
//  RegisterViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

class RegisterViewModel {
    private var memberUseCase: MemberUseCase
    
    init(memberUseCase: MemberUseCase) {
        self.memberUseCase = memberUseCase
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        return await memberUseCase.register(using: registerInfo)
    }
}
