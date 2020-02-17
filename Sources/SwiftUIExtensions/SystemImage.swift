// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Abstraction for system images which can load them in a different way on the Mac.

public struct SystemImage: View {
    let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    public var body: some View {
        #if os(macOS)
        return Image(name)
        #else
        return Image(systemName: name)
        #endif
    }
}
