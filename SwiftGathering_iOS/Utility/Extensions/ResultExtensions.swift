//
//  ResultExtensions.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

extension Result {
    @discardableResult
    func onSuccess(handle: (Success) -> ()) -> Result {
        switch self {
        case .success(let success):
            handle(success)
            return self
        case .failure(_):
            return self
        }
    }
    
    @discardableResult
    func onFailure(handle: (Failure) -> ()) -> Result {
        switch self {
        case .success(_):
            return self
        case .failure(let error):
            handle(error)
            return self
        }
    }
    
    func getOrNil() -> Success? {
        switch self {
        case .success(let success):
            return success
        case .failure(_):
            return nil
        }
    }
    
    @discardableResult
    func getOrThrow(_ replacingError: Failure? = nil) throws -> Success {
        switch self {
        case .success(let success):
            return success
        case .failure(let occurredError):
            if let replacingError = replacingError { throw replacingError }
            else { throw occurredError }
        }
    }
    
    func eraseToVoid() -> Result<Void, Failure> {
        return self
            .map { _ in
                return ()
            }
    }
}
