//
//  ParentCoordinatorProtocol.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

protocol ParentCoordinatorProtocol: CoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] { get set }
    
    func addChildCoordinator(_ child: CoordinatorProtocol?)

    func childDidFinish(_ child: CoordinatorProtocol?)
}

extension ParentCoordinatorProtocol {

    func addChildCoordinator(_ child: CoordinatorProtocol?) {
        if let child {
            childCoordinators.append(child)
        }
    }

    func childDidFinish(_ child: CoordinatorProtocol?) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}
