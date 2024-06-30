//
//  MemberUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

protocol MemberUseCase {
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error>
//    func resign(using registerInfo: RegisterInfo) async -> Result<Void, Error>
}
