//
//  HTTPMethod.swift
//  
//
//  Created by Olaf on 2021/10/14.
//

import Foundation

public enum HTTPMethod: CustomStringConvertible {
    
    case get
    case post(body: Encodable)
    
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
