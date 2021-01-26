// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 26/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol AutoLabelled where LabelView: View {
    associatedtype LabelView
    var labelView: LabelView { get }
}

public struct LabelView<Item>: View where Item: AutoLabelled {
    let item: Item
    
    public init(_ item: Item) {
        self.item = item
    }
    
    public var body: some View {
        item.labelView
    }
}
