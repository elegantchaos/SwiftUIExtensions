// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/05/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol PlatformConditionalValue {
    associatedtype T
    init(_ value: T)
    init(macOS: T?, iOS: T?, tvOS: T?, catalyst: T?, other: T)
}

public extension PlatformConditionalValue {
    init(macOS: T? = nil, iOS: T? = nil, tvOS: T? = nil, catalyst: T? = nil, other value: T) {
        #if targetEnvironment(macCatalyst)
        self.init(catalyst ?? value)
        #elseif os(macOS)
        self.init(macOS ?? value)
        #elseif os(iOS)
        self.init(iOS ?? value)
        #elseif os(tvOS)
        self.init(tvOS ?? value)
        #else
        self.init(value)
        #endif
    }
}

extension Double: PlatformConditionalValue {
    public typealias T = Double
}

#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: PlatformConditionalValue {
    public typealias T = Double
}
#endif

//
//public extension BinaryFloatingPoint {
//    init(_ value: Self, macOS: Self? = nil, iOS: Self? = nil, tvOS: Self? = nil) {
//        #if os(macOS)
//        self.init(macOS ?? value)
//        #elseif os(iOS)
//        self.init(iOS ?? value)
//        #elseif os(tvOS)
//        self.init(tvOS ?? value)
//        #else
//        self.init(value)
//        #endif
//    }
//}
