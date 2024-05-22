//
//  FriendViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 5/5/24.
//

import RxSwift

class FriendViewModel {
    var friendListInitiateInput = PublishSubject<Void>()
    
    var friendInfosSuccessSubject = PublishSubject<[FriendInfo]>()
    var friendInfosFailureSubject = PublishSubject<Error>()
    
    private let friendUseCase: FriendUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(friendUseCase: FriendUseCaseProtocol) {
        self.friendUseCase = friendUseCase
        bind()
    }
    
    private func bind() {
        friendListInitiateInput
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<Result<[FriendInfo], Error>> in
                return owner.friendUseCase.fetchFriends()
                    .map { .success($0) }
                    .catch { .just(.failure($0)) }
                    .asObservable()
            }
            .subscribe(
                with: self,
                onNext: { owner, result in
                    result.onSuccess { friends in
                        owner.friendInfosSuccessSubject.onNext(friends)
                    }
                    .onFailure { error in
                        owner.friendInfosFailureSubject.onNext(error)
                    }
                })
            .disposed(by: disposeBag)
    }
}
