//
//  GatheringUseCaseImpl.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/22/24.
//

import RxSwift
import RxCocoa

class GatheringUseCaseImpl: GatheringUseCase {
    var onStartGathering = PublishRelay<String>()
}

class GatheringStateHolder: GatheringUseCase {
    var onStartGathering = PublishRelay<String>()
    static let shared = GatheringStateHolder()
    private init() {}
}
