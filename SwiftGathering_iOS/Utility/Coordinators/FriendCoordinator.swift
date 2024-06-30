//
//  FriendCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import UIKit

final class FriendCoordinator: ChildCoordinatorProtocol {
    var navigationController: UINavigationController    
    weak var parentCoordinator: ParentCoordinatorProtocol?

    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
        
    func start(animated: Bool) {
        let friendRepository = FriendRepositoryImpl(httpHandler: HTTPHandler(), userDefaults: UserDefaults(), tokenHolder: TokenHolder.shared, memberIdHolder: MemberIdHolder.shared)
        let friendUseCase = FriendUseCaseImpl(friendRepository: friendRepository)
        let friendViewModel = FriendViewModel(friendUseCase: friendUseCase)
        let friendViewController = FriendViewController(friendViewModel: friendViewModel)
        navigationController.pushViewController(friendViewController, animated: true)
    }
}
