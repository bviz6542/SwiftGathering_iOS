//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    var loginTap = PublishSubject<LoginInfo>()
    
    var loginState: Observable<Result<Void, Error>> {
        return loginStateSubject.asObservable()
    }
    
    private let loginStateSubject = PublishSubject<Result<Void, Error>>()
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        
        loginTap
            .withUnretained(self)
            .flatMap { (owner, loginInfo) -> Observable<Result<Void, Error>> in
                return owner.loginUseCase.login(using: loginInfo)
                    .map { .success(()) }
                    .catch { .just(.failure($0)) }
                    .asObservable()
            }
            .subscribe(
                with: self,
                onNext: { (owner, loginResult) in
                    owner.loginStateSubject.onNext(loginResult)
                })
            .disposed(by: disposeBag)
    }
}
