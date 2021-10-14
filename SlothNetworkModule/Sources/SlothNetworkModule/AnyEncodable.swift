//
//  AnyEncodable.swift
//  
//
//  Created by Olaf on 2021/10/14.
//  From Moya https://github.com/Moya/Moya/blob/e4b331474bdb6e9637f3e574fcde473170070d17/Sources/Moya/AnyEncodable.swift

import Foundation

public struct AnyEncodable: Encodable {

    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
