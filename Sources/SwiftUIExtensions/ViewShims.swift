// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

// The shim provides placeholders for methods and types that don't exist on some platforms.
// These use the real methods/types when they exist,
// but default to something safe when they don't.
//
// To use, use the normal method/type, but via the shim object/type.
// For example, instead of `view.onTapGesture`, call `view.shim.onTapGesture`.
// This will do the right thing on iOS, but nothing on tvOS.

public extension View {
    #if os(tvOS)
    typealias Shim = TVOSShim<Self>
    #elseif canImport(UIKit)
    typealias Shim = UIKitShim<Self>
    #else
    typealias Shim = MacOSShim<Self>
    #endif
    
    var shim: Shim { Shim(view: self) }
}
