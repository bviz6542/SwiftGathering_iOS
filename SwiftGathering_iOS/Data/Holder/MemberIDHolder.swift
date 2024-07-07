//
//  MemberIDHolder.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 6/22/24.
//

class MemberIDHolder {
    private init() {}
    static let shared = MemberIDHolder()
    
    var memberId: Int = -1
}
