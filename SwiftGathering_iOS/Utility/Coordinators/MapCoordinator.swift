//
//  MapCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import UIKit

final class MapCoordinator: ChildCoordinatorProtocol {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinatorProtocol?

    init(navigationController: UINavigationController, parentCoordinator: ParentCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start(animated: Bool) {
        let mapRepository = MapRepositoryImpl(locationHandler: LocationHandler(), stompHandler: STOMPHandler(), memberIdHolder: MemberIDHolder.shared, httpHandler: HTTPHandler(), tokenHolder: TokenHolder.shared)
        let privateRepository = PrivateRepositoryImpl(stompHandler: PrivateSTOMPHandler(), memberIDHolder: MemberIDHolder.shared)
        let mapUseCase = MapUseCaseImpl(mapRepository: mapRepository)
        let privateUseCase = PrivateUseCaseImpl(repository: privateRepository)
        let mapViewModel = MapViewModel(mapUseCase: mapUseCase, privateUseCase: privateUseCase)
        let mapViewController = MapViewController(mapViewModel: mapViewModel)
        navigationController.pushViewController(mapViewController, animated: false)
    }
}

extension MapCoordinator {
    func navigateToWhat() {
     // TODO: navigate to what
    }
}
