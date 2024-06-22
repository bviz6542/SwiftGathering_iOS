//
//  FriendLocationOutput.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

struct FriendLocationOutput: Codable {
    let senderId: Int
    let channelId: String
    let latitude: Double
    let longitude: Double
}
