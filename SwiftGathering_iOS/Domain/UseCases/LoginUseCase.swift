//
//  LoginUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

protocol LoginUseCase {
    func execute(loginInput: LoginInput) async -> Result<Bool, Error>
}
