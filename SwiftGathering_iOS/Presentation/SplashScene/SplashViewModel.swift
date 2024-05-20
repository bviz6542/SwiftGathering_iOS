//
//  SplashViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/20/24.
//

import RxSwift
import RxCocoa

class SplashViewModel {
    var loginInitiateInput = PublishSubject<Void>()
    
    var loginSuccessOutput: Observable<Void> {
        return loginSuccessSubject.asObservable()
    }
    
    var loginErrorOutput: Observable<Error> {
        return loginErrorSubject.asObservable()
    }
    
    private let loginSuccessSubject = PublishSubject<Void>()
    private let loginErrorSubject = PublishSubject<Error>()
    private let loginUseCase: LoginUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        
        loginInitiateInput
            .withUnretained(self)
            .flatMap { (owner, _) -> Observable<Result<Void, Error>> in
                return owner.loginUseCase.loginWithPreviousLoginInfo()
                    .map { .success(()) }
                    .catch { .just(.failure($0)) }
                    .asObservable()
            }
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.loginSuccessSubject.onNext(())
                }, onError: { owner, error in
                    owner.loginErrorSubject.onError(error)
                })
            .disposed(by: disposeBag)
    }
}
