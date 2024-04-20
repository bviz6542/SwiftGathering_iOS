//
//  CoordinatorProtocol.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/15/24.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {

    var navigationController: UINavigationController { get set }
    
    func start(animated: Bool)
    
    func popViewController(animated: Bool)
}

extension CoordinatorProtocol {

    func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func popViewController(to viewController: UIViewController, animated: Bool) {
        navigationController.popToViewController(viewController, animated: animated)
    }
}
