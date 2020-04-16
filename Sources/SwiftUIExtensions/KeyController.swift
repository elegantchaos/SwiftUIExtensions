// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

/// Controller which allows you to intercept and handle keypresses.
/// (current implementation is for AppKit only, but UIKit support should be possible).
///
/// This is to fill in a current hole in SwiftUI keyboard support.
///
/// Usage:
/// Make an instance and add it to the environment.
/// In your view, register for onAppear and onDisappear.
/// In the onAppear handler, make a snapshot, then register some keys.
/// In the onDisappear, restore the snapshot.
///
/// Snapshots allow for saving and restoring the currently registered keys.
/// This is useful for nested views (eg navigation stacks), and for sheets.
/// If multiple views register a callback for a key, the last one to register will get invoked
/// first. If it returns true, it will swallow the key. If it returns false, the search will continue.
///
/// The `SheetController` class knows about `KeyController` and can pass the controller
/// on to the environment of the sheet being viewed: thus sheets can capture keys that would
/// otherwise have been handled by the view underneath.

public class KeyController: ObservableObject {
    public enum Kind {
        case up
        case down
        case both
    }
    
    public typealias Callback = () -> Bool

    public struct Snapshot {
        let triggers: [Trigger]
    }
    
    public struct Trigger {
        let code: UInt16?
        let kind: Kind
        let callback: Callback
        
        public init(code: UInt16? = nil, kind: Kind = .up, callback: @escaping Callback) {
            self.code = code
            self.kind = kind
            self.callback = callback
        }
    }
    
    public init() {
        registerForKeyboardEvents()
    }
    
    public func snapshot() -> Snapshot {
        return Snapshot(triggers: triggers)
    }
    
    public func restore(snapshot: Snapshot) {
        triggers = snapshot.triggers
    }
    
    internal var triggers: [Trigger] = []
    
    public func register(code: UInt16? = nil, kind: Kind = .down, callback: @escaping Callback) {
        triggers.append(Trigger(code: code, kind: kind, callback: callback))
    }

    func run(code: UInt16, kind: Kind) -> Bool {
        assert(kind != .both)

        print("\(code) \(kind)")
        
        for trigger in triggers.reversed() {
            if let codeToMatch = trigger.code, code != codeToMatch {
                continue
            }
            
            if trigger.kind != .both && trigger.kind != kind {
                continue
            }

            if trigger.callback() {
                return true
            }
        }

        return false
    }

}

#if canImport(AppKit)
import AppKit

public extension KeyController {
    func registerForKeyboardEvents() {
        NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown]) { (event) -> NSEvent? in
            let handled: Bool
            switch event.type {
                case .keyUp:
                    handled = self.run(code: event.keyCode, kind: .up)
                case .keyDown:
                    handled = self.run(code: event.keyCode, kind: .down)
                default:
                    handled = false
            }
            
            return handled ? nil : event
        }
    }
}

#else

public extension KeyController {
    func registerForKeyboardEvents() {
    }
}

#endif
