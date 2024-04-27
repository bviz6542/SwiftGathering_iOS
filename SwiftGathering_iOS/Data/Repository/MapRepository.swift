//
//  MapRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

protocol MapRepositoryProtocol {
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error>
}

class MapRepository: MapRepositoryProtocol {
    private var httpHandler: HTTPHandler
    
    init(httpHandler: HTTPHandler) {
        self.httpHandler = httpHandler
    }
    
    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
        let registerInput = RegisterInput(id: registerInfo.id,
                                          password: registerInfo.password,
                                          age: registerInfo.age,
                                          phoneNumber: registerInfo.phoneNumber)
        return await httpHandler
            .setPath(.register)
            .setPort(8080)
            .setMethod(.post)
            .setRequestBody(registerInput)
            .send(expecting: EmptyOutput.self)
            .eraseToVoid()
    }
}
