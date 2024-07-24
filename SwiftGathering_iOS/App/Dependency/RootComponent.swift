//
//  RootComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation
import Foundation

class RootComponent: BootstrapComponent {
    public var httpHandler: HTTPHandler {
        HTTPHandler()
    }
    
    public var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    public var tokenHolder: TokenHolder {
        TokenHolder.shared
    }
    
    public var memberIdHolder: MemberIDHolder {
        MemberIDHolder.shared
    }
    
    var repositoryComponent: RepositoryComponent {
        RepositoryComponent(parent: self)
    }
}
