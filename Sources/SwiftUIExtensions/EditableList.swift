// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class EditContext: ObservableObject {
    @Published var editing: Bool = false
}


public protocol EditableModel: ObservableObject {
    associatedtype Items: RandomAccessCollection
    var items: Items { get }
    func delete(item: Items.Element)
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
    let item: Model.Items.Element
    let content: () -> Content
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model

    public init(item: Model.Items.Element, model: Model, @ViewBuilder content: @escaping () -> Content) {
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

public struct EditableList<ID, Content, Model>: View where ID == Model.Items.Element.ID, Content : View, Model: EditableModel, Model.Items.Element: Identifiable {
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model
    let content: (Model.Items.Element, Model) -> Content
    
    public init(@ViewBuilder content: @escaping (Model.Items.Element, Model) -> Content) {
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
                    
                    self.content(item, self.model)
                }
            }
                .onDelete(perform: { at in self.model.delete(at: at) })
                .onMove(perform: editContext.editing ? { from, to in self.model.move(from: from, to: to)} : nil)
        }
    }
}

