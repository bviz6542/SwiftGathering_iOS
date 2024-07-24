//
//  RepositoryComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation
import Foundation

class RepositoryComponent: Component<RepositoryDependency> {
    public var loginRepository: LoginRepository {
        LoginRepositoryImpl(
            httpHandler: dependency.httpHandler,
            userDefaults: dependency.userDefaults,
            tokenHolder: dependency.tokenHolder,
            memberIdHolder: dependency.memberIdHolder
        )
    }
    
    var useCaseComponent: UseCaseComponent {
        UseCaseComponent(parent: self)
    }
}
