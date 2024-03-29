// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

#if os(tvOS)


public struct TVOSShim<Content> where Content: View {
    public typealias RoundedBorderTextFieldStyle = DefaultTextFieldStyle
    
    let view: Content
    
    public func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return view
    }
    
    public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return view
    }

    public func defaultShortcut() -> some View {
        return view
    }
    
    public func cancelShortcut() -> some View {
        return view
    }

}

public extension View {
    func bindEditing(to binding: Binding<Bool>) -> some View {
        return self
    }
}


public enum SizeClassShim: Equatable, Hashable {
    case compact
    case regular
}

public extension EnvironmentValues {
    var horizontalSizeClass: SizeClassShim {
        get { return .regular }
        set { }
    }
}
#endif
