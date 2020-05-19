// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 19/05/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public struct CenteringColumnPreferenceKey: PreferenceKey {
    public typealias Value = [CenteringColumnPreference]

    public static var defaultValue: [CenteringColumnPreference] = []

    public static func reduce(value: inout [CenteringColumnPreference], nextValue: () -> [CenteringColumnPreference]) {
        value.append(contentsOf: nextValue())
    }
}

public struct CenteringColumnPreference: Equatable {
    let width: CGFloat
}

public struct CenteringView: View {
    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: CenteringColumnPreferenceKey.self,
                    value: [CenteringColumnPreference(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}

public struct Label: View {
    let name: String
    let width: Binding<CGFloat?>
    public var body: some View {
        Text(name)
            .font(.callout)
            .bold()
            .frame(width: width.wrappedValue, alignment: .leading)
            .lineLimit(1)
            .background(CenteringView())
    }
    
    public init(_ name: String, width: Binding<CGFloat?>) {
        self.name = name
        self.width = width
    }
}

public extension View {
    func alignLabels(width: Binding<CGFloat?>) -> some View {
        self.onPreferenceChange(CenteringColumnPreferenceKey.self) { preferences in
            for p in preferences {
                let oldWidth = width.wrappedValue ?? CGFloat.zero
                if p.width > oldWidth {
                    width.wrappedValue = p.width
                }
            }
        }
    }
}
