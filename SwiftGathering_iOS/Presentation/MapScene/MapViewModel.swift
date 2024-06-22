//
//  MapViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/27/24.
//

import RxSwift
import CoreLocation

class MapViewModel {
    let myLocationInitiateInput = PublishSubject<Void>()
    let friendLocationInitiateInput = PublishSubject<Void>()
    let privateChannelInput = PublishSubject<Void>()
    
    let myLocationOutput = PublishSubject<CLLocation>()
    let friendLocationOutput = PublishSubject<FriendLocationOutput>()
    let privateChannelOutput = PublishSubject<String>()
    
    private let mapUseCase: MapUseCase
    private let disposeBag = DisposeBag()
    
    init(mapUseCase: MapUseCase) {
        self.mapUseCase = mapUseCase
        bind()
    }
    
    private func bind() {
        myLocationInitiateInput
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<Result<CLLocation, Error>> in
                owner.mapUseCase.setup()
                return owner.mapUseCase.fetchMyLocation()
                    .map { .success($0) }
                    .catch { .just(.failure($0)) }
                    .asObservable()
            }
            .subscribe(
                with: self,
                onNext: { owner, result in
                    result.onSuccess { location in
                        owner.myLocationOutput.onNext(location)
                        owner.mapUseCase.broadcastMyLocation(MyLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                    }
                })
            .disposed(by: disposeBag)
        
//        friendLocationInitiateInput
//            .withUnretained(self)
//            .flatMap { (owner, _) -> Observable<Result<FriendLocationOutput, Error>> in
//                return owner.mapUseCase.fetchFriendLocation()
//                    .map { .success($0) }
//                    .catch { .just(.failure($0)) }
//                    .asObservable()
//            }
//            .subscribe(
//                with: self,
//                onNext: { owner, result in
//                    result.onSuccess { output in
//                        owner.friendLocationOutput.onNext(output)
//                    }
//                })
//            .disposed(by: disposeBag)
        
        privateChannelInput
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<Result<String, Error>> in
                return owner.mapUseCase.listenToPrivateChannel()
                    .map { .success($0) }
                    .catch{ .just(.failure($0)) }
                    .asObservable()
            }
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success(let message):
                        owner.privateChannelOutput.onNext(message)
                    case .failure(_):
                        break
                    }
                })
            .disposed(by: disposeBag)
    }
}
