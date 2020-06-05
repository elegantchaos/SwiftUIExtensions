// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol EditableModel {
    associatedtype Item
    func delete(item: Item)
    func delete(at offsets: IndexSet)
}

public struct EditableRowView<ContentView, Model>: View where ContentView: View, Model: EditableModel {
    let item: Model.Item
    let model: Model
    let content: () -> ContentView
    @Environment(\.editModeShim) var editMode: EditModeShim
    
    public init(item: Model.Item, model: Model, content: @escaping () -> ContentView) {
        self.item = item
        self.model = model
        self.content = content
    }
    
    public var body: some View {
        HStack {
            if self.editMode.isEditing {
                SystemImage(.rowHandle)
                Button(action: { self.model.delete(item: self.item) })  {
                    SystemImage(.rowDelete)
                        .foregroundColor(Color.red)
                }.buttonStyle(BorderlessButtonStyle())
            }
            
            content()
        }
    }
}
