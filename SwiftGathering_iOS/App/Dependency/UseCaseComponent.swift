//
//  UseCaseComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation

class UseCaseComponent: Component<UseCaseDependency> {
    public var loginUseCase: LoginUseCase {
        LoginUseCaseImpl(loginRepository: dependency.loginRepository)
    }
    
    var splashViewComponent: SplashViewComponent {
        SplashViewComponent(parent: self)
    }
}
