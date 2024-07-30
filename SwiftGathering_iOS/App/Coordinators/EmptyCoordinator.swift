//
//  EmptyCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/4/24.
//

import UIKit

final class EmptyCoordinator: ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    private let viewComponent: ViewComponent
    weak var parentCoordinator: ParentCoordinatorProtocol?
    
    init(navigationController: UINavigationController, viewComponent: ViewComponent, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.viewComponent = viewComponent
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool) {
        navigationController.pushViewController(UIViewController(), animated: false)
    }
}
