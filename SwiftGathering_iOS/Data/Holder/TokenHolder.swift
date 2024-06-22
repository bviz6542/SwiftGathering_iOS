//
//  TokenHolder.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 6/17/24.
//

class TokenHolder {
    private init() {}
    static let shared = TokenHolder()
    
    var token: String = ""
}
