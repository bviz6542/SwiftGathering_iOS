//
//  HTTPError.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

enum HTTPError: Error {
    case invalidURLError
    case requestSetupError
    case transportError
    case serverSideError
    case responseParsingError
    case unexpectedError
}
