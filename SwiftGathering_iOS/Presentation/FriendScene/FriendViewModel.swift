//
//  FriendViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift
import RxCocoa

class FriendViewModel {
    private(set) var friendInfoUIModelList: [FriendInfoUIModel] = []
    private(set) var friendViewMode = FriendViewMode.normal
    
    let event = PublishRelay<FriendViewEvent>()
    private let disposeBag = DisposeBag()
    
    private let friendUseCase: FriendUseCase
    private let mapUseCase: MapUseCase
    private let gatheringUseCase: GatheringUseCase
    
    init(friendUseCase: FriendUseCase, mapUseCase: MapUseCase, gatheringUseCase: GatheringUseCase) {
        self.friendUseCase = friendUseCase
        self.mapUseCase = mapUseCase
        self.gatheringUseCase = gatheringUseCase
    }
    
    func initializeData() {
        event.accept(.onStartLoading)
        friendUseCase.fetchFriends()
            .do(onNext: { [weak self] _ in
                self?.event.accept(.onEndLoading)
            })
            .catch { [weak self] error in
                self?.event.accept(.onFetchFailFriendInfos(error))
                return Observable.empty()
            }
            .subscribe(onNext: { [weak self] friends in
                let friendInfoUIModels = friends.map { FriendInfoUIModel(friendInfo: $0, isSelected: false) }
                self?.friendInfoUIModelList = friendInfoUIModels
                self?.event.accept(.onUpdateFriendInfos)
            })
            .disposed(by: disposeBag)
    }
    
    func selectFriend(in index: Int) {
        if friendViewMode == .gathering {
            friendInfoUIModelList[index].isSelected.toggle()
            event.accept(.onUpdateFriendInfos)
        }
    }
    
    func startGathering() {
        createSession()
    }
    
    func cancelGathering() {
        let friendInfoUIModels = friendInfoUIModelList
            .map { FriendInfoUIModel(friendInfo: $0.friendInfo, isSelected: false) }
        friendInfoUIModelList = friendInfoUIModels
        toggleViewMode()
        event.accept(.onUpdateFriendInfos)
    }
    
    func toggleViewMode() {
        switch friendViewMode {
        case .normal: friendViewMode = .gathering
        case .gathering: friendViewMode = .normal
        }
        event.accept(.onToggleViewMode(friendViewMode))
    }
    
    private func createSession() {
        let selectedFriendIds = friendInfoUIModelList
            .filter { friendInfoUIModel in
                friendInfoUIModel.isSelected
            }
            .map { friendInfo in
                friendInfo.friendInfo.id
            }
        
        if selectedFriendIds.isEmpty { return }
        
        mapUseCase.createGathering(with: selectedFriendIds)
            .catch { [weak self] error in
                self?.event.accept(.onCreateFailGathering(error))
                return Observable.empty()
            }
            .subscribe(onNext: { [weak self] sessionId in
                self?.gatheringUseCase.onStartGathering.accept(sessionId.sessionID)
            })
            .disposed(by: disposeBag)
    }
}
