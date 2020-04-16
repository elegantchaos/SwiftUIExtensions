// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class KeyController: ObservableObject {
    public typealias KeyTrigger = () -> Bool
    
    public var upTriggers: [UInt16:KeyTrigger] = [:]
    public var downTriggers: [UInt16:KeyTrigger] = [:]

    public init() {
        NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown]) { (event) -> NSEvent? in
            let handled: Bool
            switch event.type {
                case .keyUp:
                    handled = self.keyUp(with: event)
                case .keyDown:
                    handled = self.keyDown(with: event)
                default:
                    handled = false
            }
            
            return handled ? nil : event
        }
    }
}

#if canImport(AppKit)
import AppKit

public extension KeyController {
    func runTrigger(from table: [UInt16:KeyTrigger], with event: NSEvent) -> Bool {
        print(event.keyCode)
        guard let trigger = upTriggers[event.keyCode] else { return false }
            
        return trigger()
    }
    
    func keyUp(with event: NSEvent) -> Bool {
        return runTrigger(from: upTriggers, with: event)
    }
    
    func keyDown(with event: NSEvent) -> Bool {
        return runTrigger(from: downTriggers, with: event)
    }
}

#endif
