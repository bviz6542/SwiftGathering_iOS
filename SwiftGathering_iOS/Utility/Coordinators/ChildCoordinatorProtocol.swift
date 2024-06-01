//
//  ChildCoordinatorProtocol.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

import UIKit

protocol ChildCoordinatorProtocol: CoordinatorProtocol {
    
    var parentCoordinator: ParentCoordinatorProtocol? { get set }
    
    func coordinatorDidFinish()
    
//    var viewControllerRef: UIViewController? { get set }
}

extension ChildCoordinatorProtocol {
    func coordinatorDidFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
