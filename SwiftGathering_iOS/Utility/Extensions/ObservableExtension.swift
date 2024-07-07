//
//  ObservableExtension.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 7/7/24.
//

import RxSwift

extension Observable {
    func flatMapOptionalResult<ResultType>(
        _ transform: @escaping (Element) -> Observable<Result<ResultType, Error>>?
    ) -> Observable<Result<ResultType, Error>> {
        flatMap { element -> Observable<Result<ResultType, Error>> in
            guard let observable = transform(element) else {
                return .just(.failure(Result<ResultType, Error>.ResultError.selfIsNil))
            }
            return observable
        }
    }
    
    func asResult() -> Observable<Result<Element, Error>> {
        return self.map { .success($0) }
                   .catch { error in .just(.failure(error)) }
    }
}
