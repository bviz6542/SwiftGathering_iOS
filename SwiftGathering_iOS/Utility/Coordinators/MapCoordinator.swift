//
//  MapCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import UIKit

final class MapCoordinator: ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        let mapRepository = MapRepository(locationHandler: LocationHandler(),
                                          privateRabbitMQHandler: RabbitMQHandler(),
                                          rabbitMQHandler: RabbitMQHandler())
        let mapUseCase = MapUseCase(mapRepository: mapRepository)
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
