// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Abstraction for system images which can load them in a different way on the Mac.

public struct SystemImage: View {
    public typealias Name = String
    let name: Name
    
    public init(_ name: Name) {
        self.name = name
    }
    
    public var body: some View {
        #if canImport(UIKit)
        return Image(systemName: name)
        #else
        return Image(nsImage: NSImage(named: name)!)
        #endif
    }
}

#if canImport(UIKit)

public extension SystemImage.Name {
    static var rowDelete: Self { return "minus.circle.fill" }
    static var rowHandle: Self { return "line.horizontal.3" }
}

#else
public extension SystemImage.Name {
    static var rowDelete: Self { return "NSStopProgressFreestandingTemplate" }
    static var rowHandle: Self { return "NSListViewTemplate" }
}


#endif
