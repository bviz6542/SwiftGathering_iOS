//
//  ChildCoordinatorProtocol.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

import UIKit

protocol ChildCoordinatorProtocol: CoordinatorProtocol {
    
    func coordinatorDidFinish()
    
    var viewControllerRef: UIViewController? { get set }
}
