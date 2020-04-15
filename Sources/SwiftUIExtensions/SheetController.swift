// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class SheetController: ObservableObject {
    public typealias ViewMaker = () -> AnyView
    
    @Published public var isPresented: Bool
    
    var viewMaker: ViewMaker?

    public init() {
        isPresented = false
    }
    
    func presented() -> AnyView {
        viewMaker?() ?? AnyView(EmptyView())
    }
    
    public func show(_ maker: @escaping ViewMaker) {
        viewMaker = maker
        isPresented = true
    }
    
    public func dismiss() {
        isPresented = false
        viewMaker = nil
    }
}

public extension View {
    func sheet(controlledBy controller: Binding<SheetController>) -> some View {
        self.sheet(isPresented: controller.isPresented) { controller.wrappedValue.presented() }
    }

    func sheet(controlledBy controller: EnvironmentObject<SheetController>) -> some View {
        self.sheet(isPresented: controller.projectedValue.isPresented) { controller.wrappedValue.presented() }
    }
}
