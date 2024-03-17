//
//  MainViewController.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/3/24.
//

import UIKit

class MainViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let drawingViewController = DrawingViewController()
//        drawingViewController.modalPresentationStyle = .overCurrentContext
//        present(drawingViewController, animated: true)
        
//        let mapViewController = MapViewController()
//        mapViewController.modalPresentationStyle = .overCurrentContext
//        present(mapViewController, animated: true)
        
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}

