//
//  LoginRepository.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 4/14/24.
//

import RxSwift

protocol LoginRepository {
    func login(using loginInfo: LoginInfo) -> Observable<Void>
    func fetchPreviousLoginInfo() -> Observable<LoginInfo>
}
