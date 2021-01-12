// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol ListItemLinkable {
    static func linkView(binding: Binding<Self>) -> LinkType
    associatedtype LinkType: View
}

public struct ListItemLinkView<T>: View where T: ListItemLinkable, T: ListItemViewable {
    let binding: Binding<T>
    
    public init(for item: Binding<T>) {
        self.binding = item
    }
    
    public var body: some View {
        NavigationLink(destination: T.linkView(binding: binding)) {
            ListItemView(binding: binding)
        }
    }
}
