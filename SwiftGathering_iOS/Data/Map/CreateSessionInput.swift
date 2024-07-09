//
//  CreateSessionInput.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/9/24.
//

struct CreateSessionInput: Codable {
    let senderID: Int
    let guestIDs: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case senderID = "senderId"
        case guestIDs = "guestIds"
    }
}
