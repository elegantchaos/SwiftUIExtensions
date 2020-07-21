// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if !os(tvOS)

import SwiftUI

// TODO: EditContext should really be paramterised with the Identifiable type, rather than hard-coding UUID.
//          This would complicate things a bit for things like EditButton which would need to know the exact type
//          of the EditContext. That could be avoided by splitting the context into two objects - one containing
//          just the untyped things like the edititing state, and the other containing the typed things such as
//          the selection.

public class EditContext: ObservableObject {
    @Published var editing: Bool = false
    @Published var debugging: Bool = false
    @Published var selection: Set<UUID> = []
}

public protocol EditableModel: ObservableObject where Items.Element: Identifiable {
    associatedtype Items: RandomAccessCollection
    var items: Items { get }
    func delete(item: Items.Element)
    func delete(at offsets: IndexSet)
    func move(from: IndexSet, to: Int)
}

public struct EditingView<Content>: View where Content: View {
    @State var editContext = EditContext()
    let content: () -> Content
    
    public init(debugging: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.editContext.debugging = debugging
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

public struct EditableList<ID, Content, Model>: View where ID == Model.Items.Element.ID, Content : View, Model: EditableModel {
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model
    let content: (Model.Items.Element, Model) -> Content
    
    public init(@ViewBuilder content: @escaping (Model.Items.Element, Model) -> Content) {
        self.content = content
    }

    public var body: some View {
        List(selection: self.$editContext.selection) {
            if editContext.debugging {
                Text(editContext.selection.map({ $0.uuidString }).joined(separator: ","))
            }
            
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

#endif
