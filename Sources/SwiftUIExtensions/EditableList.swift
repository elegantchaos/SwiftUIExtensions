// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public protocol EditableModel {
    associatedtype Item
    func delete(item: Item)
    func delete(at offsets: IndexSet)
    func move(from: IndexSet, to: Int)
}

public struct EditableRowView<ContentView, Model>: View where ContentView: View, Model: EditableModel {
    let item: Model.Item
    let model: Model
    let content: () -> ContentView
    @Environment(\.editModeShim) var editMode
    
    public init(item: Model.Item, model: Model, content: @escaping () -> ContentView) {
        self.item = item
        self.model = model
        self.content = content
    }
    
    public var body: some View {
        let editing: Bool = editMode?.wrappedValue == .active
        return HStack {
            if editing {
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

public struct EditButton<Content>: View where Content: View {
    @Binding var editing: Bool
    @Environment(\.editModeShim) var editMode
    let content: () -> Content
    
    public init(editing: Binding<Bool>, content: @escaping () -> Content) {
        self._editing = editing
        self.content = content
    }
    
    public var body: some View {
        Button(action: {
            self.editing = !self.editing
        }) {
            content().bindEditing(to: $editing)
        }
    }
}

public extension ForEach {
    func bindEditableList<Model>(to binding: Binding<Bool>, model: Model) -> some View where Model: EditableModel, Content: View {
        self
            .onDelete(perform: { at in model.delete(at: at) })
            .onMove(perform: binding.wrappedValue ? { from, to in model.move(from: from, to: to)} : nil)
            .bindEditing(to: binding)
    }
}
