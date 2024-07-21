//
//  STOMPPath.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/15/24.
//

enum STOMPPath {
    case location
    case drawing
    case privateChannel(myID: String)
    case sessionChannel(sessionID: String)
    
    var stringValue: String {
        switch self {
        case .location: "/pub/location"
        case .drawing: "/pub/drawing"
        case .privateChannel(myID: let myID): "/topic/private.\(myID)"
        case .sessionChannel(sessionID: let sessionID): "/topic/\(sessionID)"
        }
    }
}
