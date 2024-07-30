//
//  ProfileViewComponent.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/30/24.
//

import NeedleFoundation

class ProfileViewComponent: Component<ViewDependency> {
    var viewModel: ProfileViewModel {
        ProfileViewModel()
    }
    
    var viewController: ProfileViewController {
        ProfileViewController(viewModel: viewModel)
    }
}
