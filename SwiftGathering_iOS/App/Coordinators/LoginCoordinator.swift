//
//  LoginCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

import UIKit

final class LoginCoordinator: ParentCoordinatorProtocol, ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    private let viewComponent: ViewComponent
    weak var parentCoordinator: ParentCoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController, viewComponent: ViewComponent, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.viewComponent = viewComponent
        self.parentCoordinator = parentCoordinator
    }
        
    func start(animated: Bool) {        
        let loginViewController = viewComponent.loginViewComponent.viewController
        let loginViewModel = loginViewController.viewModel        
        loginViewModel.coordinator = self
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func navigateToTabBar() {
        coordinatorDidFinish()
    }
    
    func navigateToRegister() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController, parentCoordinator: self)
        addChildCoordinator(registerCoordinator)
        registerCoordinator.start(animated: false)
    }
}
