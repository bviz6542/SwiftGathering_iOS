//
//  MapViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

class MapViewModel {
    // Input
    let onViewDidLoad = PublishSubject<Void>()
    
    // Output
    let onReceivedSessionRequest = PublishSubject<ReceivedSessionRequestOutput>()
    
    // Legacy
    let myLocationInitiateInput = PublishSubject<Void>()
    let friendLocationInitiateInput = PublishSubject<Void>()
    
    let myLocationOutput = PublishSubject<CLLocation>()
    let friendLocationOutput = PublishSubject<FriendLocation>()
    
    private let mapUseCase: MapUseCase
    private let privateUseCase: PrivateUseCase
    private let disposeBag = DisposeBag()
    
    init(mapUseCase: MapUseCase, privateUseCase: PrivateUseCase) {
        self.mapUseCase = mapUseCase
        self.privateUseCase = privateUseCase
        bind()
    }
    
    private func bind() {
        myLocationInitiateInput
            .flatMapOptionalResult({ [weak self] in
                self?.mapUseCase.setup()
                return self?.mapUseCase.fetchMyLocation().asResult()
            })
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { [weak self] location in
                    self?.myLocationOutput.onNext(location)
                    self?.mapUseCase.broadcastMyLocation(
                        MyLocation(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                    )
                }
            })
            .disposed(by: disposeBag)
        
        friendLocationInitiateInput
            .flatMapOptionalResult({ [weak self] in
                self?.mapUseCase.fetchFriendLocation().asResult()
            })
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { location in
                    self?.friendLocationOutput.onNext(location)
                }
            })
            .disposed(by: disposeBag)
        
        onViewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.privateUseCase.startListening()
            })
            .disposed(by: disposeBag)
        
        privateUseCase.receivedSessionRequest()
            .subscribe(onNext: { [weak self] sessionRequest in
                self?.onReceivedSessionRequest.onNext(sessionRequest)
            })
            .disposed(by: disposeBag)
    }
}
