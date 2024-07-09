//
//  PrivateUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import RxSwift

class PrivateUseCaseImpl: PrivateUseCase {
    private let repository: PrivateRepository
    
    init(repository: PrivateRepository) {
        self.repository = repository
    }
    
    func startListening() {
        repository.startListening()
    }
    
    func receivedSessionRequest() -> Observable<ReceivedSessionRequestOutput> {
        repository.receivedSessionRequest()
    }
}
