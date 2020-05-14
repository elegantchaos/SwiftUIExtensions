// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

// The shim provides placeholders for methods that don't exist on some platforms.
// These call on to the real methods when they exist, but do something
// safe (or sometimes, nothing) when they don't.
//
// To use, make the normal call, but via the shim object.
// For example, instead of `view.onTapGesture`, call `view.shim.onTapGesture`.
// This will do the right thing on iOS, but nothing on tvOS.

public extension View {
    #if os(tvOS)
    var shim: TVOSShim<Self> { TVOSShim(view: self) }
    #elseif canImport(UIKit)
    var shim: UIKitShim<Self> { UIKitShim(view: self) }
    #else
    var shim: MacOSShim<Self> { MacOSShim(view: self) }
    #endif
}
