//
//  MemberUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 6/14/24.
//

import RxSwift

class MemberUseCaseImpl: MemberUseCase {
    private var memberRepository: MemberRepository
    
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        return await memberRepository.register(using: registerInfo)
    }
}
