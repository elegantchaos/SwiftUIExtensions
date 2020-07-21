// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

#if os(macOS)
    public struct MacOSShim<Content> where Content: View {
    let view: Content

    public func onTapGesture(perform action: @escaping () -> Void) -> some View {
        return view
    }

    public func contextMenu<MenuItems>(@ViewBuilder menuItems: () -> MenuItems) -> some View where MenuItems : View {
        return view
    }
        
        public struct UITextContentTypeShim {
            let wrapped: NSTextContentType?
            public static var name: UITextContentTypeShim {
                if #available(macOS 11.0, *) {
                    return UITextContentTypeShim(wrapped: NSTextContentType.name)
                } else {
                    return UITextContentTypeShim(wrapped: NSTextContentType(rawValue: "name"))
                }
            }
        }
        
        public func textContentType(_ textContentType: UITextContentTypeShim) -> some View {
            return Group {
                if #available(macOS 11.0, *) {
                    view.textContentType(textContentType.wrapped)
                } else {
                    view
                }
            }
        }

}

public extension NSTextContentType {
    static var nameShim: NSTextContentType {
        .init(rawValue: "name")
    }
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

extension NSTextContentType {
    @available(OSX 11.0, *) public static var name: NSTextContentType { .username }
    @available(OSX 11.0, *) public static var alphabet: NSTextContentType { .init(rawValue: "") }
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
