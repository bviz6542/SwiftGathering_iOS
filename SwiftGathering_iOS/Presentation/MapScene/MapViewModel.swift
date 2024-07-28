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
    weak var coordinator: MapCoordinator?
    
    let event = PublishRelay<MapViewEvent>()
    private let disposeBag = DisposeBag()
    private var isGathering: Bool = false
    
    private let mapUseCase: MapUseCase
    private let privateUseCase: PrivateUseCase
    private let gatheringUseCase: GatheringUseCase
    
    init(mapUseCase: MapUseCase, privateUseCase: PrivateUseCase, gatheringUseCase: GatheringUseCase) {
        self.mapUseCase = mapUseCase
        self.privateUseCase = privateUseCase
        self.gatheringUseCase = gatheringUseCase
        bind()
    }
    
    private func bind() {
        privateUseCase.receivedSessionRequest()
            .catch { _ in return .empty() }
            .subscribe(onNext: { [weak self] sessionRequest in
                self?.event.accept(.onReceivedSessionRequest(sessionRequest))
            })
            .disposed(by: disposeBag)
        
        gatheringUseCase.onStartGathering.asSignal()
            .emit(onNext: { [weak self] sessionID in
                self?.startGathering(with: sessionID)
            })
            .disposed(by: disposeBag)
    }
    
    func startDataFetch() {
        startListeningPrivate()
        fetchMyLocation()
    }
    
    func startGathering(with sessionID: String) {
        coordinator?.navigateToMapPage()
        startListeningGathering(with: sessionID)
        fetchFriendLocation()
        fetchFriendDrawing()
        event.accept(.onStartGathering)
    }
    
    private func startListeningPrivate() {
        privateUseCase.startListening()
    }
    
    private func fetchMyLocation() {
        mapUseCase.fetchMyLocation()
            .catch { _ in return .empty() }
            .subscribe(onNext: { [weak self] location in
                self?.event.accept(.onFetchMyLocation(location))
                
                if self?.isGathering == true {
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
    
    func broadcastMyDrawing(_ mapStroke: MapStroke) {
        mapUseCase.broadcastMyDrawing(mapStroke)
    }
    
    private func startListeningGathering(with sessionID: String) {
        isGathering = true
        mapUseCase.setup(with: sessionID)
    }
    
    private func fetchFriendLocation() {
        mapUseCase.fetchFriendLocation()
            .catch { _ in return .empty() }
            .subscribe(onNext: { [weak self] location in
                self?.event.accept(.onFetchFriendLocation(location))
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchFriendDrawing() {
        mapUseCase.fetchFriendDrawing()
            .catch { _ in return .empty() }
            .subscribe(onNext: { [weak self] mapStroke in
                self?.event.accept(.onReceiveFriendDrawing(mapStroke))
            })
            .disposed(by: disposeBag)
    }
}
