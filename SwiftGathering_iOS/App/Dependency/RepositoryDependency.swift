//
//  RepositoryDependency.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation
import Foundation

protocol RepositoryDependency: Dependency {
    var httpHandler: HTTPHandler { get }
    var userDefaults: UserDefaults { get }
    var tokenHolder: TokenHolder { get }
    var memberIdHolder: MemberIDHolder { get }
}
