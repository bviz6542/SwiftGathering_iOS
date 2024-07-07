//
//  PrivateRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import RxSwift
import Foundation

class PrivateRepositoryImpl: PrivateRepository {
    private let memberIDHolder: MemberIDHolder
    private let stompHandler: PrivateSTOMPHandler
    
    init(stompHandler: PrivateSTOMPHandler, memberIDHolder: MemberIDHolder) {
        self.stompHandler = stompHandler
        self.memberIDHolder = memberIDHolder
    }
    
    func startListening() {
        stompHandler.myID = memberIDHolder.memberId
        stompHandler.registerSocket()
    }
    
    func receivedSessionRequest() -> Observable<ReceivedSessionRequestOutput> {
        stompHandler.resultSubject.compactMap { jsonObject in
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
                  let message = try? JSONDecoder().decode(ReceivedSessionRequestOutput.self, from: jsonData)
            else { return nil }
            return message
        }
    }
}


