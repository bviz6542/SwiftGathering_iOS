//
//  PrivateRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import RxSwift

protocol PrivateRepository {
    func startListening()
    func receivedSessionRequest() -> Observable<ReceivedSessionRequestOutput>
}
