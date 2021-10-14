//
//  NetworkManageable.swift
//  
//
//  Created by Olaf on 2021/09/21.
//

import Foundation
import Combine

public protocol NetworkManageable {
    
    func dataTaskPublisher(for urlString: String, httpMethod: HTTPMethod) -> AnyPublisher<Data, NetworkError>
}
