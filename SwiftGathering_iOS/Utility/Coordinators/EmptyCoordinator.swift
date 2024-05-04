//
//  EmptyCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/4/24.
//

import UIKit

final class EmptyCoordinator: NSObject, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start(animated: Bool) {
        navigationController.pushViewController(UIViewController(), animated: false)
    }
}
