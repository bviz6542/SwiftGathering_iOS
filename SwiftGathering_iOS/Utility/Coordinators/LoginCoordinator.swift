//
//  LoginCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/21/24.
//

import UIKit

final class LoginCoordinator: ParentCoordinatorProtocol, ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
        
    func start(animated: Bool) {        
        let loginRepository = LoginRepositoryImpl(httpHandler: HTTPHandler(), userDefaults: UserDefaults(), tokenHolder: TokenHolder.shared, memberIdHolder: MemberIdHolder.shared)
        let loginUseCase = LoginUseCaseImpl(loginRepository: loginRepository)
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let loginViewController = LoginViewController(loginViewModel: loginViewModel)
        loginViewController.coordinator = self
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
