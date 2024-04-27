//
//  MapUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

protocol MapUseCaseProtocol {
//    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error>
}

class MapUseCase: MapUseCaseProtocol {
    private var mapRepository: MapRepository
    
    init(mapRepository: MapRepository) {
        self.mapRepository = mapRepository
    }
    
//    func register(using registerInfo: RegisterInfo) async -> Result<Void, Error> {
//        return await registerRepository.register(using: registerInfo)
//    }
}
