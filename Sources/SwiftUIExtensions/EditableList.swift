// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class EditContext: ObservableObject {
    @Published var editing: Bool = false
}


public protocol EditableModel: ObservableObject {
    associatedtype Item: Identifiable
    var items: [Item] { get }
    func delete(item: Item)
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
    let item: Model.Item
    let content: () -> Content
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model

    public init(item: Model.Item, model: Model, @ViewBuilder content: @escaping () -> Content) {
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

public struct WrappedForEach<Data, ID, Content>: View where Data : RandomAccessCollection, ID == Data.Element.ID, Content : View, Data.Element : Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    public var body: some View {
        ForEach<Data, ID, Content>(data, content: content)
    }
}

public struct EditingForEach<Model, Row>: View where Model: EditableModel, Row: View {
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model
    let content: (Model.Item) -> Row
    
    public init(@ViewBuilder content: @escaping (Model.Item) -> Row) {
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
