// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

#if os(macOS) && !canImport(UIKit)
public struct MacOSShim<Content> where Content: View {
    let view: Content
    
    public func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return view
    }
    
    public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return view
    }
    
    public enum UITextContentTypeShim {
        case name
    }

    #if swift(>=5.3) // HACK: workaround to check for the macOS 11 SDK, which implements textContentType
    @available(macOS 11.0, *) func applyTextContent(for type: UITextContentTypeShim) -> AnyView {
        switch type {
        case .name: return AnyView(view.textContentType(.username))
        }
    }

    public func textContentType(_ textContentType: UITextContentTypeShim) -> some View {
        if #available(macOS 11.0, *) {
        switch textContentType {
        
            case .name: return AnyView(view.textContentType(.username))
        }
        } else {
            return AnyView(view)
        }
    }

    #else

    public func textContentType(_ textContentType: UITextContentTypeShim) -> some View {
         return view
    }

    #endif
}

public enum KeyboardTypeShim {
    case namePhonePad
    case alphabet
}

public enum AutocapitalizationTypeShim {
    case none
}

public extension View {
    func keyboardType(_ type: KeyboardTypeShim) -> some View {
        return self
    }
    
    func autocapitalization(_ type: AutocapitalizationTypeShim) -> some View {
        return self
    }
    
    
}

public struct EditModeShimKey: EnvironmentKey {
    public static var defaultValue: Binding<EditModeShim>? { nil }
}

public extension EnvironmentValues {
    var editModeShim: Binding<EditModeShim>? {
        get { return self[EditModeShimKey.self] }
        set { self[EditModeShimKey.self] = newValue }
    }
}

public extension View {
    func bindEditing(to binding: Binding<Bool>) -> some View {
        let value: EditModeShim = binding.wrappedValue ? .active : .inactive
        return environment(\.editModeShim, .constant(value))
    }
}

public enum EditModeShim: Equatable, Hashable {
    
    /// The view content cannot be edited.
    case inactive
    
    /// The view is in a temporary edit mode.
    ///
    /// The definition of temporary might vary by platform or specific control.
    /// As an example, temporary edit mode may be engaged over the duration of
    /// a swipe gesture.
    case transient
    
    /// The view content can be edited.
    case active
    
    /// Indicates whether a view is being edited.
    public var isEditing: Bool {
        switch self {
        case .active: return true
        default: return false
        }
    }
}

#endif
