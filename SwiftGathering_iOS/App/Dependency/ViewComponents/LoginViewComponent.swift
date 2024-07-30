//
//  LoginViewComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/30/24.
//

import NeedleFoundation

class LoginViewComponent: Component<ViewDependency> {
    var viewModel: LoginViewModel {
        LoginViewModel(loginUseCase: dependency.loginUseCase)
    }
    
    var viewController: LoginViewController {
        LoginViewController(viewModel: viewModel)
    }
}
