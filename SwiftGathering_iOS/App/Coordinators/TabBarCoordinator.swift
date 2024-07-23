//
//  TabBarCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/4/24.
//

import UIKit

final class TabBarCoordinator: ParentCoordinatorProtocol, ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinatorProtocol?
    var childCoordinators: [CoordinatorProtocol] = []

    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
        
    func start(animated: Bool) {
        let tabNavigationControllers = TabBarItemType
            .allCases
            .map { tabBarType -> UITabBarItem in
                createTabBarItem(of: tabBarType)
            }
            .map { tabBarItem -> UINavigationController in
                createTabNavigationController(tabBarItem: tabBarItem)
            }
            .map { tabNavigationController -> UINavigationController in
                startTabCoordinator(tabNavigationController: tabNavigationController)
                return tabNavigationController
            }
        
        let tabBarController = UITabBarController()
        configureTabBarController(tabBarController, using: tabNavigationControllers)
        navigationController.pushViewController(tabBarController, animated: animated)
    }
    
    private func createTabBarItem(of tabType: TabBarItemType) -> UITabBarItem {
        return UITabBarItem(
            title: tabType.toName(),
            image: UIImage(systemName: tabType.toIconName()),
            tag: tabType.toInt()
        )
    }
    
    private func createTabNavigationController(tabBarItem: UITabBarItem) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.navigationBar.topItem?.title = TabBarItemType(index: tabBarItem.tag)?.toName()
        tabNavigationController.tabBarItem = tabBarItem
        return tabNavigationController
    }
    
    private func startTabCoordinator(tabNavigationController: UINavigationController) {
        let tabBarItemTag: Int = tabNavigationController.tabBarItem.tag
        guard let tabBarItemType: TabBarItemType = TabBarItemType(index: tabBarItemTag) else { return }
        switch tabBarItemType {
        case .map:
            let mapCoordinator = MapCoordinator(navigationController: tabNavigationController, parentCoordinator: self)
            addChildCoordinator(mapCoordinator)
            mapCoordinator.start(animated: false)
        case .friend:
            let friendCoordinator = FriendCoordinator(navigationController: tabNavigationController, parentCoordinator: self)
            addChildCoordinator(friendCoordinator)
            friendCoordinator.start(animated: false)
        case .unknown:
            let emptyCoordinator = EmptyCoordinator(navigationController: tabNavigationController, parentCoordinator: self)
            addChildCoordinator(emptyCoordinator)
            emptyCoordinator.start(animated: false)
        case .profile:
            let profileCoordinator = ProfileCoordinator(navigationController: tabNavigationController, parentCoordinator: self)
            addChildCoordinator(profileCoordinator)
            profileCoordinator.start(animated: false)
        }
    }
    
    private func configureTabBarController(
        _ tabBarController: UITabBarController,
        using tabNavigationControllers: [UIViewController]
    ) {
        tabBarController.setViewControllers(tabNavigationControllers, animated: false)
        tabBarController.selectedIndex = TabBarItemType.map.toInt()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.backgroundColor = UIColor(named: "tabBarBackgroundColor")
        tabBarController.tabBar.tintColor = .opaqueSeparator
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.navigationItem.hidesBackButton = true
        navigationController.isNavigationBarHidden = true
        tabBarController.navigationController?.isNavigationBarHidden = true
    }
    
    func childDidFinish(_ child: CoordinatorProtocol?) {
        childCoordinators.removeAll()
        coordinatorDidFinish()
    }
}
