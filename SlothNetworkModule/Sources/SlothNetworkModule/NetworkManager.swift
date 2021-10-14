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
    
    public func dataTaskPublisher(for urlString: String, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) -> AnyPublisher<Data, NetworkError> {
        guard let request = makeURLRequest(with: urlString, httpMethod: httpMethod, httpHeaders: httpHeaders) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
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
    
    private func makeURLRequest(with urlString: String, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "\(httpMethod)"
        
        httpHeaders?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
