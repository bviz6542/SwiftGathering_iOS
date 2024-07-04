//
//  GatheringRepositoryImpl.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/5/24.
//

import RxSwift

class GatheringRepositoryImpl {
    private let httpHandler: HTTPHandler
    private let tokenHolder: TokenHolder
    private let memberIdHolder: MemberIdHolder
    
    init(httpHandler: HTTPHandler, tokenHolder: TokenHolder, memberIdHolder: MemberIdHolder) {
        self.httpHandler = httpHandler
        self.tokenHolder = tokenHolder
        self.memberIdHolder = memberIdHolder
    }
    
    func createGathering(with memberIDs: [Int]) -> Observable<Void> {
        let createGatheringInput = CreateGatheringInput(senderID: memberIdHolder.memberId, memberIDs: memberIDs)
        return httpHandler
            .setPath(.gathering)
            .setMethod(.post)
            .addHeader(key: "Authorization", value: "Bearer \(tokenHolder.token)")
            .setRequestBody(createGatheringInput)
            .rxSend(expecting: EmptyOutput.self)
            .map { _ in () }
    }
}
