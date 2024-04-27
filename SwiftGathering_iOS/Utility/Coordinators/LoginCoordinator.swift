//
//  LoginCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

import UIKit

final class LoginCoordinator: NSObject, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start(animated: Bool) {
        let loginRepository = LoginRepository(httpHandler: HTTPHandler(), userDefaults: UserDefaults.standard)
        let loginUseCase = LoginUseCase(loginRepository: loginRepository)
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let loginViewController = LoginViewController(loginViewModel: loginViewModel)
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: false)
    }
}

extension LoginCoordinator {
    func navigateToMap() {
        popViewController(animated: true)
        let mapCoordinator = MapCoordinator(navigationController: navigationController)
        mapCoordinator.start(animated: false)
    }
    
    func navigateToRegister() {
        popViewController(animated: false)
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.start(animated: false)
    }
}
