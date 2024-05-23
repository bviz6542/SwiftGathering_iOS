//
//  HTTPHandler.swift
//  SwiftGathering_iOS
//
//  Created by 정준우 on 3/17/24.
//

import Foundation
import RxSwift

class HTTPHandler {
    private var host: String = ""
    private var port: Int?
    private var path: HTTPPath? = nil
    private var queryItems: [String: String] = [:]
    private var method: HTTPMethod? = nil
    private var headers: [String: String] = [:]
    private var requestBody: Codable?
    
    func setHost(_ host: String) -> HTTPHandler {
        self.host = host
        return self
    }
    
    func setPort(_ port: Int) -> HTTPHandler {
        self.port = port
        return self
    }
    
    func setPath(_ path: HTTPPath) -> HTTPHandler {
        self.path = path
        return self
    }
    
    func setQueryParameters(_ queryItems: [String: String]) -> HTTPHandler {
        self.queryItems = queryItems
        return self
    }
    
    func addQueryParameter(key: String, value: String) -> HTTPHandler {
        self.queryItems.updateValue(value, forKey: key)
        return self
    }
    
    func setMethod(_ method: HTTPMethod) -> HTTPHandler {
        self.method = method
        return self
    }
    
    func setHeaders(_ headers: [String: String]) -> HTTPHandler {
        self.headers = headers
        return self
    }
    
    func addHeader(key: String, value: String) -> HTTPHandler {
        self.headers.updateValue(value, forKey: key)
        return self
    }
    
    func setRequestBody(_ requestBody: Codable) -> HTTPHandler {
        self.requestBody = requestBody
        return self
    }
    
    private func buildURLRequest() throws -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = "http"
        
        if host.isEmpty {
            urlComponent.host = "localhost"
        }
        
        if let port = port {
            urlComponent.port = port
        }
        
        if let path = path {
            urlComponent.path = path.stringValue
        }
        
        urlComponent.queryItems = queryItems.map({ (key, value) in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = urlComponent.url else { throw HTTPError.invalidURLError }
        var urlRequest = URLRequest(url: url)
        guard let method = method else { throw HTTPError.requestSetupError }
        urlRequest.httpMethod = method.rawValue

        headers.updateValue("application/json", forKey: "Content-Type")
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let requestBody = requestBody {
            guard let jsonData = try? JSONEncoder().encode(requestBody) else { throw HTTPError.requestSetupError }
            urlRequest.httpBody = jsonData
        }
        
        return urlRequest
    }
    
    func send<OutputType: Codable>(expecting outputType: OutputType.Type) async -> Result<OutputType, Error> {
        do {
            let urlRequest = try buildURLRequest()
            let (data, response) = try await sendRequestAndFetchResponse(with: urlRequest)
            try handleHTTPSStatusCodes(in: response)
            let responseData: OutputType = try decodeResponseData(data: data)
            return .success(responseData)
            
        } catch {
            return .failure(error)
        }
    }
    
    private func sendRequestAndFetchResponse(with request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, response)
        } catch {
            throw HTTPError.transportError
        }
    }
    
    private func handleHTTPSStatusCodes(in response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            if (200...399 ~= response.statusCode) {
                return
            } else if (400...599 ~= response.statusCode) {
                throw HTTPError.serverSideError
            } else {
                throw HTTPError.unexpectedError
            }
        }
    }
    
    private func decodeResponseData<OutputType: Codable>(data: Data) throws -> OutputType {
        do {
            if OutputType.self is EmptyOutput.Type {
                return EmptyOutput() as! OutputType
            }
            return try JSONDecoder().decode(OutputType.self, from: data)
        } catch {
            throw HTTPError.responseParsingError
        }
    }
    
    private func rxBuildURLRequest() -> Observable<URLRequest> {
        do {
            return .just(try buildURLRequest())
        } catch {
            return .error(error)
        }
    }
    
    private func rxSendRequestAndFetchResponse(with request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return URLSession.shared.rx.response(request: request)
    }
    
    private func rxHandleHTTPSStatusCodes(in response: HTTPURLResponse) -> Observable<Void> {
        if (200...399 ~= response.statusCode) {
            return .just(())
        } else if (400...599 ~= response.statusCode) {
            return .error(HTTPError.serverSideError)
        } else {
            return .error(HTTPError.unexpectedError)
        }
    }
    
    private func rxDecodeResponseData<OutputType: Codable>(data: Data) -> Observable<OutputType> {
        do {
            return .just(try decodeResponseData(data: data))
        } catch {
            return .error(error)
        }
    }
    
    func rxSend<OutputType: Codable>(expecting outputType: OutputType.Type) -> Observable<OutputType> {
        rxBuildURLRequest()
            .withUnretained(self)
            .flatMap { (owner: HTTPHandler, request: URLRequest) in
                owner.rxSendRequestAndFetchResponse(with: request)
            }
            .withUnretained(self)
            .flatMap { (owner: HTTPHandler, result: (response: HTTPURLResponse, data: Data)) in
                owner.rxHandleHTTPSStatusCodes(in: result.response)
                    .map { result.data }
            }
            .withUnretained(self)
            .flatMap { (owner: HTTPHandler, data: Data) -> Observable<OutputType> in
                owner.rxDecodeResponseData(data: data)
            }
    }
}
