// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Uses the geometry-reader & preferences method to align a bunch of labels in a container.
public struct AlignedLabelContainer<Content>: View where Content: View {
    let content: () -> Content
    @State private var labelWidth: CGFloat = 0
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .onPreferenceChange(AlignedLabel.PrefKey.self) { newWidth in
                labelWidth = newWidth
            }
            .environment(\.labelWidth, labelWidth)
    }
}

/// A single-line text view which is automatically sized
/// to be as large as the largest label in the containing view.
public struct AlignedLabel: View {
    struct EnvKey: EnvironmentKey {
        public static let defaultValue: CGFloat = 0
    }

    struct PrefKey: PreferenceKey {
        public static var defaultValue: CGFloat = 0
        public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            let next = nextValue()
            if next > value {
                value = next
            }
        }
    }

    let name: String
    @Environment(\.labelWidth) var width: CGFloat
    let alignment: Alignment
    let font: Font
    let bold: Bool

    public var body: some View {
        let text = Text(name).font(font)
        let view = bold ? text.bold() : text
        return view.background(WidthReader<AlignedLabel.PrefKey>())
            .lineLimit(1)
            .frame(width: width == 0 ? nil : width, alignment: alignment)
    }
    
    public init(_ name: String, alignment: Alignment = .trailing, font: Font = .body, bold: Bool = false) {
        self.name = name
        self.alignment = alignment
        self.font = font
        self.bold = bold
    }
}


fileprivate extension EnvironmentValues {
    var labelWidth: CGFloat {
        get {
            return self[AlignedLabel.EnvKey.self]
        }
        set {
            self[AlignedLabel.EnvKey.self] = newValue
        }
    }
}
