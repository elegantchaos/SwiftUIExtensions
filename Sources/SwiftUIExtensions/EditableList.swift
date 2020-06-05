// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class EditContext: ObservableObject {
    @Published var editing: Bool = false
}


public protocol EditableModel: ObservableObject {
    associatedtype EditableItem: Identifiable
    typealias Items = [EditableItem]
    var items: [EditableItem] { get }
    func delete(item: EditableItem)
    func delete(at offsets: IndexSet)
    func move(from: IndexSet, to: Int)
}

public struct EditingView<Content>: View where Content: View {
    @State var editContext = EditContext()
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environmentObject(editContext)
            .bindEditing(to: $editContext.editing)
    }

}

public struct EditableRowView<Model, Content>: View where Content: View, Model: EditableModel {
    let item: Model.EditableItem
    let content: () -> Content
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model

    public init(item: Model.EditableItem, model: Model, @ViewBuilder content: @escaping () -> Content) {
        self.item = item
        self.content = content
    }

    public var body: some View {
        return HStack {
            if editContext.editing {
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
    @EnvironmentObject var editContext: EditContext
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Button(action: {
            self.editContext.editing = !self.editContext.editing
        }) {
            content()
        }
    }
}

public struct WrappedForEach<Data, ID, Content, Model>: View where Data : RandomAccessCollection, ID == Data.Element.ID, Content : View, Data.Element : Identifiable, Model: EditableModel {
    @EnvironmentObject var editContext: EditContext
    let data: Data
    let model: Model
    let content: (Data.Element) -> Content
    
    public init(_ data: Data, model: Model, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        self.model = model
    }

    public var body: some View {
        ForEach<Data, ID, Content>(data, content: content)
            .onDelete(perform: { at in self.model.delete(at: at) })
            .onMove(perform: editContext.editing ? { from, to in self.model.move(from: from, to: to)} : nil)
    }
}

public struct EditingForEach<Model, Row>: View where Model: EditableModel, Row: View {
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model
    let content: (Model.EditableItem) -> Row
    
    public init(@ViewBuilder content: @escaping (Model.EditableItem) -> Row) {
        self.content = content
    }
    
    public var body: some View {
        List {
            ForEach(model.items) { item in
                HStack {
                    if self.editContext.editing {
                        SystemImage(.rowHandle)
                        Button(action: { self.model.delete(item: item) })  {
                            SystemImage(.rowDelete)
                                .foregroundColor(Color.red)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    self.content(item)
                }
            }
            .onDelete(perform: { at in self.model.delete(at: at) })
            .onMove(perform: editContext.editing ? { from, to in self.model.move(from: from, to: to)} : nil)
        }
    }
}

public extension ForEach {
    func bindEditableList<Model>(to binding: Binding<Bool>, model: Model) -> some View where Model: EditableModel, Content: View {
        self
            .onDelete(perform: { at in model.delete(at: at) })
            .onMove(perform: binding.wrappedValue ? { from, to in model.move(from: from, to: to)} : nil)
    }
}
