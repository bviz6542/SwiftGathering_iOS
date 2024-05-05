//
//  FriendViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift

class FriendViewModel {
    var friendInfos: Observable<[FriendInfo]> {
        friendInfoSubject.asObservable().compactMap { $0 }
    }
    
    private let friendInfoSubject = BehaviorSubject<[FriendInfo]?>(value: nil)
    private let friendUseCase: FriendUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(friendUseCase: FriendUseCaseProtocol) {
        self.friendUseCase = friendUseCase
        bind()
    }
    
    private func bind() {
        friendUseCase.fetchFriends()
            .subscribe { [weak self] infos in
                self?.friendInfoSubject.onNext(infos)
            } onError: { [weak self] error in
                self?.friendInfoSubject.onError(error)
            }
            .disposed(by: disposeBag)
    }
}
