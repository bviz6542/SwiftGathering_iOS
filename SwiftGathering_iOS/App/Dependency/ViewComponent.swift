//
//  ViewComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/30/24.
//

import NeedleFoundation

class ViewComponent: Component<ViewDependency> {
    var rootViewComponent: RootViewComponent {
        RootViewComponent(parent: self)
    }
    
    var loginViewComponent: LoginViewComponent {
        LoginViewComponent(parent: self)
    }
    
    var profileViewComponent: ProfileViewComponent {
        ProfileViewComponent(parent: self)
    }
}
