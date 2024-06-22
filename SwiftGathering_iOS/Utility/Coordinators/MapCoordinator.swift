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
        let mapRepository = MapRepositoryImpl(locationHandler: LocationHandler())
        let mapUseCase = MapUseCaseImpl(mapRepository: mapRepository)
        let mapViewModel = MapViewModel(mapUseCase: mapUseCase)
        let mapViewController = MapViewController(mapViewModel: mapViewModel)
        navigationController.pushViewController(mapViewController, animated: false)
    }
}

extension MapCoordinator {
    func navigateToWhat() {
     // TODO: navigate to what
    }
}
