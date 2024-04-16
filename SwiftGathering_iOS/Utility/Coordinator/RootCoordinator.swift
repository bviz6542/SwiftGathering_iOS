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
        let httpHandler = HTTPHandler()
        let loginRepository = LoginRepository(httpHandler: httpHandler)
        let loginUseCase = LoginUseCase(loginRepository: loginRepository)
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let mainViewController = MainViewController()
        navigationController.pushViewController(mainViewController, animated: animated)
    }
}

extension RootCoordinator {
    func navigateFromMain() {
        
    }
    
    private func navigateToMap() {
        
    }
    
    private func navigateToRegister() {
        
    }
}

//final class RootCoordinator: NSObject, ParentCoordinatorProtocol {
//
//    var childCoordinators = [Coordinator]()
//}
//
//extension RootCoordinator {
//    
//    // MARK: - nav From
//    func navigateFromSplashVc(isLoggedIn: Bool, user: User? = nil) {
//        if let user, isLoggedIn {
//            navigateToApp(userData: user)
//        } else {
//            navigateToLogister()
//        }
//    }
//
//    
//    // MARK: - nav To
//    private func navigateToApp(userData: User) {
//        let baseTabBarController = BaseTabBarController(currentUser: userData, coordinator: self)
//        baseTabBarController.coordinator = self
//        navigationController.pushViewController(baseTabBarController, animated: true)
//    }
//    
//    private func navigateToLogister() {
//        let logisterCoordinator = LogisterCoordinator(navigationController: navigationController)
//        logisterCoordinator.parent = self
//        addChildCoordinator(logisterCoordinator)
//        logisterCoordinator.start(animated: true)
//    }
//    
//    
//    // MARK: - flow Finished
//    func logisterFinished(user: User, animated: Bool) {
//        navigateToApp(userData: user)
//    }
//}
