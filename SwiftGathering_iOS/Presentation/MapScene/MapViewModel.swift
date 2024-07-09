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
    let onFetchMyLocation = PublishSubject<CLLocation>()
    let onFetchFriendLocation = PublishSubject<FriendLocation>()
    
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
                self?.startListening()
                self?.fetchMyLocation()
                self?.fetchFriendLocation()
            })
            .disposed(by: disposeBag)
        
        privateUseCase.receivedSessionRequest()
            .subscribe(onNext: { [weak self] sessionRequest in
                self?.onReceivedSessionRequest.onNext(sessionRequest)
            })
            .disposed(by: disposeBag)
    }
    
    private func startListening() {
        privateUseCase.startListening()
    }
    
    private func fetchMyLocation() {
        mapUseCase.setup()
        mapUseCase.fetchMyLocation().asResult()
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { [weak self] location in
                    self?.onFetchMyLocation.onNext(location)
                    self?.mapUseCase.broadcastMyLocation(
                        MyLocation(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchFriendLocation() {
        mapUseCase.fetchFriendLocation().asResult()
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { location in
                    self?.onFetchFriendLocation.onNext(location)
                }
            })
            .disposed(by: disposeBag)
    }
}
