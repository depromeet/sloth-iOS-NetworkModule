//
//  NetworkManageable.swift
//  
//
//  Created by Olaf on 2021/09/21.
//

import Foundation
import Combine

public protocol NetworkManageable {
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<Data, NetworkError>
}
