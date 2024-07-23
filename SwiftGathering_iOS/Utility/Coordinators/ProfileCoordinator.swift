//
//  ProfileCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 5/24/24.
//

import UIKit

final class ProfileCoordinator: ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinatorProtocol?
    
    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool) {
        let viewModel = ProfileViewModel()
        viewModel.coordinator = self
        let profileViewController = ProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(profileViewController, animated: animated)
    }
    
    func navigateToSplash() {
        coordinatorDidFinish()
    }
}
