// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

#if !os(tvOS) && canImport(UIKit)

public struct UIKitShim<Content> where Content: View {
    public typealias RoundedBorderTextFieldStyle = SwiftUI.RoundedBorderTextFieldStyle

    let view: Content
    
    public func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return view.onTapGesture(perform: action)
    }
    
    public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return view.contextMenu(menuItems: menuItems)
    }
    
    public func textContentType(_ textContentType: UITextContentType?) -> some View {
            view.textContentType(textContentType)
    }

    @available(iOS 14.0, *) public func defaultShortcut() -> some View {
        view
            .keyboardShortcut(.defaultAction)
    }
    
    @available(iOS 14.0, *) public func cancelShortcut() -> some View {
        view
            .keyboardShortcut(.cancelAction)
    }
}

public typealias EditModeShim = EditMode

public extension EnvironmentValues {
    var editModeShim: Binding<EditModeShim>? {
        get { self.editMode }
        set { self.editMode = newValue }
    }
}


public extension View {
    func bindEditing(to binding: Binding<Bool>) -> some View {
        environment(\.editMode, .constant(binding.wrappedValue ? .active : .inactive))
    }
}

#endif
