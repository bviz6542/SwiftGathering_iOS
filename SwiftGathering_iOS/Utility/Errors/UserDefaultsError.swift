//
//  UserDefaultsError.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/20/24.
//

enum UserDefaultsError: Error {
    case doesNotExist
    case encodeFailed
    case decodeFailed
}
