//
//  HTTPPath.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

enum HTTPPath {
    case login
    case register
    
    var stringValue: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        }
    }
}
