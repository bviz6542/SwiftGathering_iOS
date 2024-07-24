//
//  UseCaseDependency.swift
//  SwiftGathering_iOS
//
//  Created by mraz on 7/23/24.
//

import NeedleFoundation

protocol UseCaseDependency: Dependency {
    var loginRepository: LoginRepository { get }
}
