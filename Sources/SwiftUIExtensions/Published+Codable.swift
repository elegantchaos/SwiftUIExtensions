// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

// Inspired by https://blog.hobbyistsoftware.com/2020/01/adding-codeable-to-published/.

import Foundation
import SwiftUI

extension Published: Encodable where Value: Encodable {
    enum PublishedEncodingError: Error {
        case cantGetPublishedValue
        case publishedValueNotEncodable
    }
    
    public func encode(to encoder: Encoder) throws {
        guard let valueChild = Mirror(reflecting: self).children.first(where: { $0.label == "value" }) else {
            throw PublishedEncodingError.cantGetPublishedValue
        }
        
        guard let value = valueChild.value as? Encodable else {
            throw PublishedEncodingError.publishedValueNotEncodable
        }

        try value.encode(to: encoder)
    }
}

extension Published: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self = Published(initialValue:try Value(from:decoder))
    }
}
