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
    let selection: Binding<Item.ID?>
    
    public init(_ item: Item, selection: Binding<Item.ID?>) {
        self.item = item
        self.selection = selection
    }
    
    public var body: some View {
        NavigationLink(destination: item.linkView, tag: item.id, selection: selection) {
            LabelView(item)
        }
    }
}

public struct OLinkView<Item>: View where Item: AutoLinked, Item: ObservableObject {
    @ObservedObject var item: Item
    let selection: Binding<Item.ID?>
    
    public init(_ item: Item, selection: Binding<Item.ID?>) {
        self.item = item
        self.selection = selection
    }
    
    public var body: some View {
        NavigationLink(destination: item.linkView, tag: item.id, selection: selection) {
            OLabelView(item)
        }
    }
}
