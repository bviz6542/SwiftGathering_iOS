//
//  RootCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

import UIKit

final class RootCoordinator: NSObject, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start(animated: Bool) {
        let loginRepository = LoginRepository(httpHandler: HTTPHandler(), userDefaults: UserDefaults.standard)
        let loginUseCase = LoginUseCase(loginRepository: loginRepository)
        let splashViewModel = SplashViewModel(loginUseCase: loginUseCase)
        let splashViewController = SplashViewController(splashViewModel: splashViewModel)
        splashViewController.coordinator = self
        navigationController.pushViewController(splashViewController, animated: animated)
    }
}

extension RootCoordinator {
    func navigateToTabBar() {
        popViewController(animated: true)
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start(animated: false)
    }
    
    func navigateToLogin() {
        popViewController(animated: true)
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start(animated: true)
    }
}
