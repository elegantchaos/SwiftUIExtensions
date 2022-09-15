// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/12/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

@available(macOS 12.0, iOS 15.0, tvOS 15.0, *) public extension View {
    func traceChanges(for label: @autoclosure () -> String) {
        #if DEBUG
            print("\(label())» ", terminator: "")
            Self._printChanges()
        #endif
    }

    func traceChanges() {
        #if DEBUG
        Self._printChanges()
        #endif
    }
}
