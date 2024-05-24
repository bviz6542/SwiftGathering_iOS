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
        print(parentCoordinator)
    }
    
    func start(animated: Bool) {
        let profileViewController = ProfileViewController()
        profileViewController.coordinator = self
        navigationController.pushViewController(profileViewController, animated: animated)
    }
    
    func coordinatorDidFinish() {
        print("dd \(parentCoordinator)")
        parentCoordinator?.childDidFinish(self)
    }
}
