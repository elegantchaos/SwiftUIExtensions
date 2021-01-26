// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol AutoLinked: AutoLabelled, Identifiable where ItemView: View {
    associatedtype ItemView
    var linkView: ItemView { get }
}

public struct LinkView<Item>: View where Item: AutoLinked {
    let item: Item
    
    public init(_ item: Item) {
        self.item = item
    }
    
    public var body: some View {
        NavigationLink(destination: item.linkView) {
            LabelView(item)
        }
        .tag(item.id)

    }
}
