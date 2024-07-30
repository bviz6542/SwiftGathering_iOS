//
//  LoginViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    let event = PublishRelay<LoginViewEvent>()
    private let disposeBag = DisposeBag()
    
    weak var coordinator: LoginCoordinator?
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(using loginInfo: LoginInfo) {
        loginUseCase.login(using: loginInfo).asResult()
            .subscribe(onNext: { [weak self] result in
                result
                    .onSuccess { _ in
                        self?.coordinator?.navigateToTabBar()
                    }
                    .onFailure { error in
                        self?.event.accept(.onFailureLogin(error))
                    }
            })
            .disposed(by: disposeBag)
    }
    
    func register() {
        coordinator?.navigateToRegister()
    }
}
