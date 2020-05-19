// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Preference key which stores the widths of labels.
fileprivate struct LabelWidthPreferenceKey: PreferenceKey {
    public typealias Value = [LabelWidth]

    public static var defaultValue: [LabelWidth] = []

    public static func reduce(value: inout [LabelWidth], nextValue: () -> [LabelWidth]) {
        value.append(contentsOf: nextValue())
    }
}

/// The width of an individual label
fileprivate struct LabelWidth: Equatable {
    let width: CGFloat
}

/// View which captures its own width and stores it in a preference.
fileprivate struct WidthReader: View {
    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: LabelWidthPreferenceKey.self,
                    value: [LabelWidth(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}

/// A single-line text view which is automatically sized
/// to be as large as the largest label in the containing view.
public struct Label: View {
    let name: String
    let width: Binding<CGFloat?>
    let alignment: Alignment
    public var body: some View {
        Text(name)
            .font(.callout)
            .bold()
            .frame(width: width.wrappedValue, alignment: alignment)
            .lineLimit(1)
            .background(WidthReader())
    }
    
    public init(_ name: String, width: Binding<CGFloat?>, alignment: Alignment = .trailing) {
        self.name = name
        self.width = width
        self.alignment = alignment
    }
}

public extension View {
    /// Call this on the outer view containing all of the labels.
    /// - Parameter width: a @State variable defined on the containing view, used to store the maximum label width.
    /// - Returns: A view which automatically updates the binding when the label width preference is changed.
    func alignLabels(width: Binding<CGFloat?>) -> some View {
        self.onPreferenceChange(LabelWidthPreferenceKey.self) { preferences in
            for p in preferences {
                let oldWidth = width.wrappedValue ?? CGFloat.zero
                if p.width > oldWidth {
                    width.wrappedValue = p.width
                }
            }
        }
    }
}
