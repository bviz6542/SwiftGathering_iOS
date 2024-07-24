//
//  ViewDependency.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation

protocol ViewDependency: Dependency {
    var loginUseCase: LoginUseCase { get }
}
