//
//  RegisterCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

import UIKit

final class RegisterCoordinator: ParentCoordinatorProtocol, ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool) {
        let registerRepository = RegisterRepository(httpHandler: HTTPHandler())
        let registerUseCase = RegisterUseCase(registerRepository: registerRepository)
        let registerViewModel = RegisterViewModel(registerUseCase: registerUseCase)
        let registerViewController = RegisterViewController(registerViewModel: registerViewModel)
        registerViewController.coordinator = self
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
    func navigateToLogin() {
        popViewController(animated: true)
        coordinatorDidFinish()
    }
}
