//
//  PrivateUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import RxSwift

protocol PrivateUseCase {
    func startListening()
    func receivedSessionRequest() -> Observable<ReceivedSessionRequestOutput>
}
