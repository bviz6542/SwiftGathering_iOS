//
//  SplashViewModel.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/20/24.
//

import RxSwift
import RxCocoa

class SplashViewModel {
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    weak var coordinator: RootCoordinator?
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login() {
        loginUseCase.loginWithPreviousLoginInfo().asResult()
            .asSignal(onErrorSignalWith: .empty())
            .emit(onNext: { [weak self] result in
                result
                    .onSuccess { [weak self] in
                        self?.coordinator?.navigateToTabBar()
                    }
                    .onFailure { [weak self] error in
                        self?.coordinator?.navigateToLogin()
                    }
            })
            .disposed(by: disposeBag)
    }
}
