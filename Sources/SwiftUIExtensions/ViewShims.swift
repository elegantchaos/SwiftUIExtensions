// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

// Placeholders for methods that don't exist on some platforms.
// These call on to the real methods when they exist, but do something
// safe (or sometimes, nothing) when they don't.

public extension View {
    // MARK: tvOS
    
    #if os(tvOS)
    
    public func onTapGestureShim(perform action: @escaping () -> Void) -> some View {
        return self
    }
    
    #elseif canImport(UIKit)
    
    // MARK: iOS/tvOS
    
    func onTapGestureShim(perform action: @escaping () -> Void) -> some View {
        return onTapGesture(perform: action)
    }
    
    #else // MARK: AppKit Overrides

    func onTapGestureShim(perform action: @escaping () -> Void) -> some View {
        return self
    }
    #endif
}
