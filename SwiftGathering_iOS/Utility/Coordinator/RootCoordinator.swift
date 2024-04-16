//
//  RootCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

import UIKit

//final class RootCoordinator: NSObject, ParentCoordinatorProtocol {
//    
//    var navigationController: UINavigationController
//    var childCoordinators = [Coordinator]()
//
//    
//    // MARK: - init & start
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start(animated: Bool) {
//        let viewModel = SplashViewModel(coordinator: self)
//        let fakeSplashVC = SplashScreenViewController()
//        fakeSplashVC.viewModel = viewModel
//        navigationController.pushViewController(fakeSplashVC, animated: animated)
//    }
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
