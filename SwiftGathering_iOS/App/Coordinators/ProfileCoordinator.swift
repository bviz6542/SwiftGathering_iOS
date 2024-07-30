//
//  ProfileCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 5/24/24.
//

import UIKit

final class ProfileCoordinator: ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    private let viewComponent: ViewComponent
    weak var parentCoordinator: ParentCoordinatorProtocol?
    
    init(navigationController: UINavigationController, viewComponent: ViewComponent, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.viewComponent = viewComponent
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool) {
        let profileViewController = viewComponent.profileViewComponent.viewController
        let profileViewModel = profileViewController.viewModel
        profileViewModel.coordinator = self
        navigationController.pushViewController(profileViewController, animated: animated)
    }
    
    func navigateToSplash() {
        coordinatorDidFinish()
    }
}
