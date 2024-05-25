//
//  EmptyCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/4/24.
//

import UIKit

final class EmptyCoordinator: ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinatorProtocol?
    
    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool) {
        navigationController.pushViewController(UIViewController(), animated: false)
    }
}
