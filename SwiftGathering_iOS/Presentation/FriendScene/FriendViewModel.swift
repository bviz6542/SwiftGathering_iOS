//
//  FriendViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift

class FriendViewModel {
    // Input
    var onViewDidLoad = PublishSubject<Void>()
    var onTappedGatheringButton = PublishSubject<Void>()
    var onSelectFriendCell = PublishSubject<Int>()
    var onTappedGatheringStartButton = PublishSubject<Void>()
    var onTappedGatheringCancelButton = PublishSubject<Void>()
    
    // Output
    var onFetchFriendInfos = PublishSubject<[FriendInfoUIModel]>()
    var onFetchFailFriendInfos = PublishSubject<Error>()
    var onCreateFailGathering = PublishSubject<Error>()
    var onChangeMode = PublishSubject<FriendViewMode>()
    var onShowIndicator = PublishSubject<Void>()
    var onHideIndicator = PublishSubject<Void>()
    
    private var friendInfoUIModelList: [FriendInfoUIModel] = []
    
    private let friendUseCase: FriendUseCase
    private let mapUseCase: MapUseCase
    private let gatheringUseCase: GatheringUseCase
    private let disposeBag = DisposeBag()
    
    init(friendUseCase: FriendUseCase, mapUseCase: MapUseCase, gatheringUseCase: GatheringUseCase) {
        self.friendUseCase = friendUseCase
        self.mapUseCase = mapUseCase
        self.gatheringUseCase = gatheringUseCase
        bind()
    }
    
    private func bind() {
        onViewDidLoad
            .flatMapOptionalResult { [weak self] in
                self?.onShowIndicator.onNext(())
                return self?.friendUseCase.fetchFriends().asResult()
            }
            .subscribe(onNext: { [weak self] result in
                self?.onHideIndicator.onNext(())
                result
                    .onFailure { [weak self] error in
                        self?.onFetchFailFriendInfos.onNext(error)
                    }
                    .onSuccess { friends in
                        let friendInfoUIModels = friends.map { FriendInfoUIModel(friendInfo: $0, isSelected: false) }
                        self?.friendInfoUIModelList = friendInfoUIModels
                        self?.onFetchFriendInfos.onNext(friendInfoUIModels)
                        self?.onChangeMode.onNext(.normal)
                    }
            })
            .disposed(by: disposeBag)
        
        onTappedGatheringButton
            .subscribe(onNext: { [weak self] in
                self?.onChangeMode.onNext(.gathering)
            })
            .disposed(by: disposeBag)
        
        onSelectFriendCell
            .subscribe(onNext: { [weak self] index in
                guard let friendInfoUIModelList = self?.friendInfoUIModelList else { return }
                friendInfoUIModelList[index].isSelected.toggle()
                self?.onFetchFriendInfos.onNext(friendInfoUIModelList)
            })
            .disposed(by: disposeBag)
        
        onTappedGatheringStartButton
            .subscribe(onNext: { [weak self] in
                self?.createSession()
            })
            .disposed(by: disposeBag)
        
        onTappedGatheringCancelButton
            .subscribe(onNext: { [weak self] in
                let friendInfoUIModels = self?.friendInfoUIModelList.map { FriendInfoUIModel(friendInfo: $0.friendInfo, isSelected: false) } ?? []
                self?.friendInfoUIModelList = friendInfoUIModels
                self?.onFetchFriendInfos.onNext(friendInfoUIModels)
                self?.onChangeMode.onNext(.normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func createSession() {
        let selectedFriendIds = friendInfoUIModelList
            .filter { friendInfoUIModel in
                friendInfoUIModel.isSelected
            }
            .map { friendInfo in
                friendInfo.friendInfo.id
            }
        
        mapUseCase.createGathering(with: selectedFriendIds)
            .catch { [weak self] error in
                self?.onCreateFailGathering.onNext(error)
                return Observable.empty()
            }
            .subscribe(onNext: { [weak self] sessionId in
                self?.gatheringUseCase.onStartGathering.accept(sessionId.sessionID)
            })
            .disposed(by: disposeBag)
    }
}
