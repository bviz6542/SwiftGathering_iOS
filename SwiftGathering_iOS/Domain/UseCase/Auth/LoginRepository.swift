//
//  LoginRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/14/24.
//

import RxSwift

protocol LoginRepository {
    func login(using loginInfo: LoginInfo) -> Observable<LoginOutput>
    func fetchPreviousLoginInfo() -> Observable<LoginInfo>
    func saveLoginInfo(using loginInfo: LoginInfo) -> Observable<Void>
    func saveToken(using loginOutput: LoginOutput) -> Observable<Void>
}
