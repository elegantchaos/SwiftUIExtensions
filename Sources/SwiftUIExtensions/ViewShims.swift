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
    
    func onTapGestureShim(perform action: @escaping () -> Void) -> some View {
        return self
    }
    
    func contextMenuShim<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return self
    }

    #elseif canImport(UIKit)
    
    // MARK: iOS/tvOS
    
    func onTapGestureShim(perform action: @escaping () -> Void) -> some View {
        return onTapGesture(perform: action)
    }
    
    func contextMenuShim<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return contextMenu(menuItems: menuItems)
    }

    #else // MARK: AppKit Overrides

    func onTapGestureShim(perform action: @escaping () -> Void) -> some View {
        return self
    }
    #endif
}
