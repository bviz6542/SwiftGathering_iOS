//
//  MapViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import RxCocoa
import CoreLocation

class MapViewModel {
    // Input
    let onViewDidLoad = PublishSubject<Void>()
    let onConfirmStartGathering = PublishRelay<String>()
    
    // Output
    let onReceivedSessionRequest = PublishSubject<ReceivedSessionRequestOutput>()
    let onFetchMyLocation = PublishSubject<CLLocation>()
    let onFetchFriendLocation = PublishSubject<FriendLocation>()
    let onStartGathering = PublishRelay<Void>()
    let onEndGathering = PublishRelay<Void>()
    let onReceiveFriendDrawing = PublishRelay<MapStroke>()
    
    private var isGathering: Bool = false
    private let mapUseCase: MapUseCase
    private let privateUseCase: PrivateUseCase
    private let gatheringUseCase: GatheringUseCase
    private let disposeBag = DisposeBag()
    
    weak var coordinator: MapCoordinator?
    
    init(mapUseCase: MapUseCase, privateUseCase: PrivateUseCase, gatheringUseCase: GatheringUseCase) {
        self.mapUseCase = mapUseCase
        self.privateUseCase = privateUseCase
        self.gatheringUseCase = gatheringUseCase
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
            .asSignal()
            .emit(onNext: { [weak self] sessionID in
                self?.startGathering(with: sessionID)
            })
            .disposed(by: disposeBag)
        
        privateUseCase.receivedSessionRequest()
            .subscribe(onNext: { [weak self] sessionRequest in
                self?.onReceivedSessionRequest.onNext(sessionRequest)
            })
            .disposed(by: disposeBag)
        
        gatheringUseCase.onStartGathering
            .asSignal()
            .emit(onNext: { [weak self] sessionID in
                self?.startGathering(with: sessionID)
            })
            .disposed(by: disposeBag)
    }
    
    private func startGathering(with sessionID: String) {
        coordinator?.navigateToMapPage()
        startListeningGathering(with: sessionID)
        fetchFriendLocation()
        fetchFriendDrawing()
        onStartGathering.accept(())
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
    
    func broadcastMyDrawing(_ mapStroke: MapStroke) {
        mapUseCase.broadcastMyDrawing(mapStroke)
    }
    
    private func startListeningGathering(with sessionID: String) {
        isGathering = true
        mapUseCase.setup(with: sessionID)
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
    
    private func fetchFriendDrawing() {
        mapUseCase.fetchFriendDrawing().asResult()
            .subscribe(onNext: { [weak self] result in
                result.onSuccess { [weak self] mapStroke in
                    self?.onReceiveFriendDrawing.accept(mapStroke)
                }
            })
            .disposed(by: disposeBag)
    }
}
