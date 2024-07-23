//
//  SplashViewComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation

class SplashViewComponent: Component<ViewDependency> {
    var viewModel: SplashViewModel {
        SplashViewModel(loginUseCase: dependency.loginUseCase)
    }
    
    var viewController: SplashViewController {
        SplashViewController(viewModel: viewModel)
    }
}
