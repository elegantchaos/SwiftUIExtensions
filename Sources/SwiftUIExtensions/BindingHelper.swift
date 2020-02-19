// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public extension ObservedObject.Wrapper {
    
    
    /// Given a bound object that has a property which contains an array, return a binding for an item in that array.
    /// - Parameters:
    ///   - item: the item we need the binding for
    ///   - path: key path of the property containing the array
    /// - Returns: binding for the item
    ///
    /// This is useful where you're doing `ForEach` on an array property of an observed object, and you need a binding
    /// to the array elements, in order to pass them into a sub-view.
    func binding<Item>(for item: Item, in path: KeyPath<Self, Binding<Array<Item>>>) -> Binding<Item> where Item: Equatable {
        let boundlist = self[keyPath: path]
        let index = boundlist.wrappedValue.firstIndex(of: item)!
        let binding = (self[keyPath: path])[index]
        return binding
    }
    
}

public extension Binding {
    /// Given a bound array, return a binding for an item in it.
    /// - Parameter item: The item we need the binding for.
    /// - Returns: Binding to the item.
    ///
    /// This is useful where you're doing `ForEach` on a bound array, and you need a binding
    /// to the array elements, in order to pass them into a sub-view.
    func binding<Item>(for item: Item) -> Binding<Item> where Value == Array<Item>, Item: Equatable {
        let index = wrappedValue.firstIndex(of: item)!
        let binding = self[index]
        return binding
    }
    
    /// Given a bound array, return a binding to some property of an item in it.
    /// - Parameters:
    ///   - path: Path to the property we want a binding for.
    ///   - item: The item in the array we need the binding for.
    /// - Returns: Binding to the item's property.
    ///
    /// This is useful where you're doing `ForEach` on a bound array, and you need a binding
    /// to some property of each elements, in order to pass it into another view.
    func binding<ElementType, PropertyType>(for path: KeyPath<Binding<ElementType>, Binding<PropertyType>>, of item: ElementType) -> Binding<PropertyType> where Value == Array<ElementType>, ElementType: Equatable {
        let index = wrappedValue.firstIndex(of: item)!
        let element = self[index]
        let binding = element[keyPath: path]
        return binding
    }

}
