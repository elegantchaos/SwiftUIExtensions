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
///
/// ## Environment
///
/// It would be great if we could just grab the entire environment
/// from the presenting view and apply it to the sheet view
/// (or if it was just automatically inherited by the sheet view).
///
/// Sadly, right now this doesn't happen and there seems no way to do it.
///
/// You can apply environment values in the block you pass to `show()`.
/// However, it's a pain for the hosting view which supplies that block
/// to have to surface every important environment value just so that it
/// can pass it to the sheet view.
///
/// To work round this, we have a `environmentSetter` property on the
/// sheet controller, which is a block that applies environment settings to the
/// sheet view. You can set this once when you create the sheet controller, and
/// use it to apply global settings and objects.


public class SheetController: ObservableObject {
    public typealias ViewMaker = () -> AnyView
    public typealias EnvironmentSetter = (AnyView) -> AnyView

    @Published fileprivate var isPresented: Bool
    fileprivate var viewMaker: ViewMaker?
    
    /// Block which applies an environment to the sheet.
    public var environmentSetter: EnvironmentSetter?
    
    fileprivate var presented: some View {
        guard let view = viewMaker?() else {
            return AnyView(EmptyView())
        }
        
        if let setter = environmentSetter {
            return setter(view)
        } else {
            return AnyView(view.environmentObject(self))
        }
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
        self.sheet(isPresented: controller.projectedValue.isPresented) {
            return controller.wrappedValue.presented
        }
    }
}
