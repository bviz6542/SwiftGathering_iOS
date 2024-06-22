//
//  MemberIdHolder.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 6/22/24.
//

class MemberIdHolder {
    private init() {}
    static let shared = MemberIdHolder()
    
    var memberId: Int = -1
}
