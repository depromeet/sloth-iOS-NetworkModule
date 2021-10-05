//
//  NetworkManager.swift
//  
//
//  Created by Olaf on 2021/09/21.
//

import Foundation
import Combine

public enum NetworkError: Error {
    
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
    
    public func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Data, NetworkError> {
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
