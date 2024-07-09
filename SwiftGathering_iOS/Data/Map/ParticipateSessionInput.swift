//
//  ParticipateSessionInput.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/9/24.
//

struct ParticipateSessionInput: Codable {
    let sessionID: Int
    let memberID: Int
    
    private enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case memberID = "memberId"
    }
}
