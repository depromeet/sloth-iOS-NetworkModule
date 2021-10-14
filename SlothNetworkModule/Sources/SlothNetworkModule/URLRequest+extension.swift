//
//  URLRequest+extension.swift
//  
//
//  Created by Olaf on 2021/10/14.
//

import Foundation

extension URLRequest {
    
    mutating func addBody(with httpMethod: HTTPMethod) throws {
        switch httpMethod {
        case .get:
            break
            
        case .post(let body):
            let encoded = try JSONEncoder().encode(AnyEncodable(body))
            httpBody = encoded
        }
    }
}
