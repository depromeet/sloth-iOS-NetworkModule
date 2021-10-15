//
//  NetworkManageable.swift
//  
//
//  Created by Olaf on 2021/09/21.
//

import Foundation
import Combine

public typealias HTTPHeaders = [String: String]?

public protocol NetworkManageable {
    
    func dataTaskPublisher(for urlString: String, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) -> AnyPublisher<Data, NetworkError>
    func dataTaskPublisher(for url: URL?, httpMethod: HTTPMethod, httpHeaders: HTTPHeaders) -> AnyPublisher<Data, NetworkError>
}
