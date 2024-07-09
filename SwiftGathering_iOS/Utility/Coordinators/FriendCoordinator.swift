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
        let friendRepository = FriendRepositoryImpl(httpHandler: HTTPHandler(), userDefaults: UserDefaults(), tokenHolder: TokenHolder.shared, memberIdHolder: MemberIDHolder.shared)
        let mapRepository = MapRepositoryImpl(locationHandler: LocationHandler(), stompHandler: STOMPHandler(), memberIdHolder: MemberIDHolder.shared, httpHandler: HTTPHandler(), tokenHolder: TokenHolder.shared)
        let friendUseCase = FriendUseCaseImpl(friendRepository: friendRepository)
        let mapUseCase = MapUseCaseImpl(mapRepository: mapRepository)
        let friendViewModel = FriendViewModel(friendUseCase: friendUseCase, mapUseCase: mapUseCase)
        let friendViewController = FriendViewController(friendViewModel: friendViewModel)
        navigationController.pushViewController(friendViewController, animated: true)
    }
}
