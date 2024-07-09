//
//  ReceivedSessionRequestOutput.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

struct ReceivedSessionRequestOutput: Codable {
    let sessionID: Int
    let participantIDs: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case participantIDs = "participantIds"
    }
}
