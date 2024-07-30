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
    
    private lazy var viewComponent = {
        RootComponent().repositoryComponent.useCaseComponent.viewComponent
    }()
        
    func start(animated: Bool) {
        registerProviderFactories()
        let viewController = viewComponent.rootViewComponent.viewController
        viewController.viewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func navigateToTabBar() {
        popViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            viewComponent: viewComponent,
            parentCoordinator: self
        )
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start(animated: false)
    }
    
    func navigateToLogin() {
        popViewController(animated: true)
        let loginCoordinator = LoginCoordinator(
            navigationController: navigationController,
            viewComponent: viewComponent,
            parentCoordinator: self
        )
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
