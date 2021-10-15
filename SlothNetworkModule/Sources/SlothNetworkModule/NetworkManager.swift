//
//  NetworkManager.swift
//  
//
//  Created by Olaf on 2021/09/21.
//

import Foundation
import Combine

public enum NetworkError: Error {
    
    case invalidURL
    case invalidBody
    case invalidHttpResponse
    case invalidStatusCode(statusCode: Int)
    case emptyData
    case unknownError(error: Error)
}

public struct NetworkManager: NetworkManageable {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func dataTaskPublisher(for url: URL?, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) -> AnyPublisher<Data, NetworkError> {
        let request: URLRequest
        
        do {
            request = try makeURLRequest(with: url, httpMethod: httpMethod, httpHeaders: httpHeaders)
        } catch {
            if let error = error as? NetworkError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                return Fail(error: .unknownError(error: error)).eraseToAnyPublisher()
            }
        }
        
        return processingNetworkResponse(with: request)
    }
    
    public func dataTaskPublisher(for urlString: String, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) -> AnyPublisher<Data, NetworkError> {
        let request: URLRequest
        
        do {
            request = try makeURLRequest(with: urlString, httpMethod: httpMethod, httpHeaders: httpHeaders)
        } catch {
            if let error = error as? NetworkError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                return Fail(error: .unknownError(error: error)).eraseToAnyPublisher()
            }
        }
        
        return processingNetworkResponse(with: request)
    }
    
    private func makeURLRequest(with urlString: String, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "\(httpMethod)"
        do {
            try request.addBody(with: httpMethod)
        } catch {
            throw NetworkError.invalidBody
        }
        
        request.allHTTPHeaderFields = httpHeaders
        
        return request
    }
    
    private func makeURLRequest(with url: URL?, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) throws -> URLRequest {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "\(httpMethod)"
        do {
            try request.addBody(with: httpMethod)
        } catch {
            throw NetworkError.invalidBody
        }
        
        request.allHTTPHeaderFields = httpHeaders
        
        return request
    }
    
    private func processingNetworkResponse(with request: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidHttpResponse
                }
                
                guard (200..<300) ~= httpResponse.statusCode else {
                    throw NetworkError.invalidStatusCode(statusCode: httpResponse.statusCode)
                }
                
                if data.isEmpty {
                    throw NetworkError.emptyData
                }
                
                return data
            }
            .mapError { error -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                } else {
                    return .unknownError(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
}
