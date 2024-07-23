//
//  RootCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

import UIKit

final class RootCoordinator: ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start(animated: Bool) {
        registerProviderFactories()
        let splashViewComponent = RootComponent().repositoryComponent.useCaseComponent.splashViewComponent
        splashViewComponent.viewModel.coordinator = self
        navigationController.pushViewController(splashViewComponent.viewController, animated: animated)
    }
    
    func navigateToTabBar() {
        popViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, parentCoordinator: self)
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start(animated: false)
    }
    
    func navigateToLogin() {
        popViewController(animated: true)
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, parentCoordinator: self)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start(animated: true)
    }
    
    func childDidFinish(_ child: CoordinatorProtocol?) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
        if child is TabBarCoordinator {
            navigateToLogin()
        }
        if child is LoginCoordinator {
            navigateToTabBar()
        }
    }
}
