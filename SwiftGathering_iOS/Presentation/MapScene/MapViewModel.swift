//
//  MapViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

class MapViewModel {
    private let myLocationSubject = BehaviorSubject<CLLocation?>(value: nil)
    private let friendLocationSubject = BehaviorSubject<FriendLocationOutput?>(value: nil)

    var myLocation: Observable<CLLocation> {
        return myLocationSubject.asObservable().compactMap { $0 }
    }
    
    var friendLocation: Observable<FriendLocationOutput> {
        return friendLocationSubject.asObservable().compactMap { $0 }
    }
    
    private let disposeBag = DisposeBag()
    
    private var mapUseCase: MapUseCaseProtocol
    
    init(mapUseCase: MapUseCaseProtocol) {
        self.mapUseCase = mapUseCase
        bind()
    }
    
    private func bind() {
        mapUseCase.fetchMyLocation()
            .subscribe(onNext: { [weak self] location in
                self?.myLocationSubject.onNext(location)
            }, onError: { [weak self] error in
                self?.myLocationSubject.onError(error)
            })
            .disposed(by: disposeBag)
        
        mapUseCase.fetchFriendLocation()
            .subscribe(onNext: { [weak self] location in
                self?.friendLocationSubject.onNext(location)
            }, onError: { [weak self] error in
                self?.friendLocationSubject.onError(error)
            })
            .disposed(by: disposeBag)
    }
}
