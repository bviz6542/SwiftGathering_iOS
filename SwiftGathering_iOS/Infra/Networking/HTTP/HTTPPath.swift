//
//  HTTPPath.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

enum HTTPPath {
    case login
    case register
    case friends(memberID: String)
    case gathering
    
    var stringValue: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/members"
        case .friends(memberID: let memberID):
            return "/members/\(memberID)/friends"
        case .gathering:
            return "/gatherings"
        }
    }
}
