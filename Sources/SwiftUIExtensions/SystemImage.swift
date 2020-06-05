// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Abstraction for system images which can load them in a different way on the Mac.

public struct SystemImage: View {
    public struct Name: ExpressibleByStringLiteral, RawRepresentable {
        public typealias StringLiteralType = String
        public let rawValue: String
        public init(rawValue value: String) {
            rawValue = value
        }
        public init(stringLiteral value: String) {
            rawValue = value
        }
    }

    let name: Name
    
    public init(_ name: Name) {
        self.name = name
    }
    
    public var body: some View {
        #if os(macOS)
        return Image(nsImage: NSImage(named: name.rawValue)!)
        #else
        return Image(systemName: name.rawValue)
        #endif
    }
}

#if os(macOS)

public extension SystemImage.Name {
    static var rowDelete: Self { return "NSStopProgressFreestandingTemplate" }
    static var rowHandle: Self { return "NSListViewTemplate" }
}

#endif
