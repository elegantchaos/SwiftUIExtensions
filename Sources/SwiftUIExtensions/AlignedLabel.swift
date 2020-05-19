// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

/**
 Uses the geometry-reader & preferences method to align a bunch of labels
 in a container.
 */

import SwiftUI

/// Preference key which stores an array of label widths.
fileprivate struct LabelWidthPreferenceKey: PreferenceKey {
    public typealias Value = [CGFloat]
    public static var defaultValue: [CGFloat] = []
    public static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

/// View which captures its own width and stores it in a preference.
fileprivate struct WidthReader: View {
    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: LabelWidthPreferenceKey.self,
                    value: [geometry.frame(in: CoordinateSpace.global).width]
                )
        }
    }
}

/// A single-line text view which is automatically sized
/// to be as large as the largest label in the containing view.
public struct Label: View {
    let name: String
    let width: Binding<CGFloat>
    let alignment: Alignment
    let font: Font
    let bold: Bool

    public var body: some View {
        let text = Text(name).font(font)
        let view = bold ? text.bold() : text
        return view.background(WidthReader())
            .lineLimit(1)
            .frame(width: width.wrappedValue == 0 ? nil : width.wrappedValue, alignment: alignment)
    }
    
    public init(_ name: String, width: Binding<CGFloat>, alignment: Alignment = .trailing, font: Font = .body, bold: Bool = false) {
        self.name = name
        self.width = width
        self.alignment = alignment
        self.font = font
        self.bold = bold
    }
}

public extension View {
    /// Call this on the outer view containing all of the labels.
    /// - Parameter width: a @State variable defined on the containing view, used to store the maximum label width.
    /// - Returns: A view which automatically updates the binding when the label width preference is changed.
    func alignLabels(width: Binding<CGFloat>) -> some View {
        self.onPreferenceChange(LabelWidthPreferenceKey.self) { preferences in
            for p in preferences {
                let oldWidth = width.wrappedValue
                if p > oldWidth {
                    width.wrappedValue = p
                }
            }
        }
    }
}
