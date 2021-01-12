// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol ListItemViewable {
    static func labelView(binding: Binding<Self>) -> LabelType
    static func iconView(binding: Binding<Self>) -> Image?
    associatedtype LabelType: View
}

public struct ListItemView<T>: View where T: ListItemViewable {
    let binding: Binding<T>
    
    public var body: some View {
        HStack {
            if let icon = T.iconView(binding: binding) {
                icon
            }
            T.labelView(binding: binding)
        }
    }
}
