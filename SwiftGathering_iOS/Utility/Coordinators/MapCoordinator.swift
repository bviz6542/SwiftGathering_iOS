//
//  MapCoordinator.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import UIKit

final class MapCoordinator: NSObject, ParentCoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func start(animated: Bool) {
        let mapRepository = MapRepository(locationHandler: LocationHandler(),
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
