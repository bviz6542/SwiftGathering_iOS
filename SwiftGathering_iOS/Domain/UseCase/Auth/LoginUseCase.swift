//
//  LoginUseCase.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/28/24.
//

import RxSwift

protocol LoginUseCase {
    func login(using loginInfo: LoginInfo) -> Observable<Void>
    func loginWithPreviousLoginInfo() -> Observable<Void>
}
