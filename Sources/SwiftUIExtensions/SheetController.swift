// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Utility class for controlling the presentation of sheets.
///
/// Your root content view should own one of these, or have one passed to it
/// as a binding / in the environment.
///
/// You hook it up with `.sheet(controlledBy:)`.
///
/// E.g:
///
///    struct ContentView: View {
///        @EnvironmentObject var sheetController: SheetController
///
///        var body: some View {
///          VStack {
///            Text("My Content Here)
///          }.sheet(controlledBy: _sheetController)
///        }
///    }
///
/// To display a sheet, a child view calls `show()` on the controller,
/// and passes a block which returns the view to show.
///
/// To dismiss the sheet, a child view calls `dimisss()` on the controller.

public class SheetController: ObservableObject {
    public typealias ViewMaker = () -> AnyView
    
    @Published fileprivate var isPresented: Bool
    fileprivate var viewMaker: ViewMaker?
    fileprivate var presented: AnyView {
        viewMaker?() ?? AnyView(EmptyView())
    }

    public init() {
        isPresented = false
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
        self.sheet(isPresented: controller.isPresented, onDismiss: {
            controller.wrappedValue.dismiss()
        }) { controller.wrappedValue.presented }
    }

    func sheet(controlledBy controller: EnvironmentObject<SheetController>, keyController: KeyController? = nil) -> some View {
        self.sheet(isPresented: controller.projectedValue.isPresented) { () -> AnyView in
            let sheetView = controller.wrappedValue.presented
            if let controller = keyController {
                return AnyView(sheetView.environmentObject(controller))
            } else {
                return sheetView
            }
        }
    }
}
