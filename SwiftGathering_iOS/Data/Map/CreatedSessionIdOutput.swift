//
//  CreatedSessionIdOutput.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/14/24.
//

struct CreatedSessionIdOutput: Codable {
    let sessionID: String
    
    private enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
    }
}
