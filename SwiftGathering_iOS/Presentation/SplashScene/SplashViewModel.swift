//
//  SplashViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/20/24.
//

import RxSwift
import RxCocoa

class SplashViewModel {
    var loginState: Observable<Void> {
        return loginStateSubject.asObservable().compactMap { $0 }
    }
    
    private let loginStateSubject = BehaviorSubject<Void?>(value: nil)
    private let loginUseCase: LoginUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        
        loginUseCase.loginWithPreviousLoginInfo()
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    owner.loginStateSubject.onNext(())
                },
                onFailure: { owner, error in
                    owner.loginStateSubject.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
