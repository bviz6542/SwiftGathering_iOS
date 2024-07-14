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
    let onConfirmStartGathering = PublishSubject<Int>()
    
    // Output
    let onReceivedSessionRequest = PublishSubject<ReceivedSessionRequestOutput>()
    let onFetchMyLocation = PublishSubject<CLLocation>()
    let onFetchFriendLocation = PublishSubject<FriendLocation>()
    
    private var isGathering: Bool = false
    private let mapUseCase: MapUseCase
    private let privateUseCase: PrivateUseCase
    private let disposeBag = DisposeBag()
    
    init(mapUseCase: MapUseCase, privateUseCase: PrivateUseCase) {
        self.mapUseCase = mapUseCase
        self.privateUseCase = privateUseCase
        bind()
    }
    
    private func bind() {
        onViewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.startListeningPrivate()
                self?.fetchMyLocation()
            })
            .disposed(by: disposeBag)
        
        onConfirmStartGathering
            .subscribe(onNext: { [weak self] sessionID in
                self?.startListeningGathering(with: sessionID)
                self?.fetchFriendLocation()
            })
            .disposed(by: disposeBag)
        
        privateUseCase.receivedSessionRequest()
            .subscribe(onNext: { [weak self] sessionRequest in
                self?.onReceivedSessionRequest.onNext(sessionRequest)
            })
            .disposed(by: disposeBag)
    }
    
    private func startListeningPrivate() {
        privateUseCase.startListening()
    }
    
    private func fetchMyLocation() {
        mapUseCase.fetchMyLocation().asResult()
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { [weak self] location in
                    self?.onFetchMyLocation.onNext(location)
                    
                    if self?.isGathering == true {
                        self?.mapUseCase.broadcastMyLocation(
                            MyLocation(
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude
                            )
                        )
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func startListeningGathering(with sessionID: Int) {
        isGathering = true
        mapUseCase.setup(with: sessionID)
    }
    
    private func fetchFriendLocation() {
        mapUseCase.fetchFriendLocation().asResult()
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { location in
                    print(location)
                    self?.onFetchFriendLocation.onNext(location)
                }
            })
            .disposed(by: disposeBag)
    }
}
