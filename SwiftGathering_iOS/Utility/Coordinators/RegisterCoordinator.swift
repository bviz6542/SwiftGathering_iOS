//
//  RegisterCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

import UIKit

final class RegisterCoordinator: NSObject, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start(animated: Bool) {
        let registerRepository = RegisterRepository(httpHandler: HTTPHandler())
        let registerUseCase = RegisterUseCase(registerRepository: registerRepository)
        let registerViewModel = RegisterViewModel(registerUseCase: registerUseCase)
        let registerViewController = RegisterViewController(registerViewModel: registerViewModel)
        registerViewController.coordinator = self
        navigationController.pushViewController(registerViewController, animated: true)
    }
}

extension RegisterCoordinator {
    func navigateToLogin() {
        popViewController(animated: true)
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start(animated: true)
    }
}
