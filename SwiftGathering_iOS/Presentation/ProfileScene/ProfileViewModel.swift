//
//  ProfileViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/21/24.
//

class ProfileViewModel {
    weak var coordinator: ProfileCoordinator?
    
    func navigateToSplash() {
        coordinator?.navigateToSplash()
    }
}
