//
//  TabBarCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/4/24.
//

import UIKit

final class TabBarCoordinator: NSObject, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    
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
}

extension TabBarCoordinator {
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
            let mapCoordinator = MapCoordinator(navigationController: tabNavigationController)
            mapCoordinator.start(animated: false)
        case .friend:
            let friendCoordinator = FriendCoordinator(navigationController: tabNavigationController)
            friendCoordinator.start(animated: false)
        case .unknown:
            let emptyCoordinator = EmptyCoordinator(navigationController: tabNavigationController)
            emptyCoordinator.start(animated: false)
        case .profile:
            let emptyCoordinator = EmptyCoordinator(navigationController: tabNavigationController)
            emptyCoordinator.start(animated: false)
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
    }
}
