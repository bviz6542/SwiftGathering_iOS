//
//  ProfileViewController.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 5/24/24.
//

import UIKit

class ProfileViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    
    @IBAction func onTouchedLogout(_ sender: UIButton) {
        coordinator?.navigateToSplash()
    }
}
