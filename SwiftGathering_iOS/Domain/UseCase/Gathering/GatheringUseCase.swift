//
//  GatheringUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/22/24.
//

import RxSwift
import RxCocoa

protocol GatheringUseCase {
    var onStartGathering: PublishRelay<String> { get set }
}
