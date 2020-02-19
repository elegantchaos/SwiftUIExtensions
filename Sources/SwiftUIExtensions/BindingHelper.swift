// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/02/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public extension ObservedObject.Wrapper {
    func binding<Item>(for item: Item, in path: KeyPath<Self, Binding<Array<Item>>>) -> Binding<Item> where Item: Equatable {
        let boundlist = self[keyPath: path]
        let index = boundlist.wrappedValue.firstIndex(of: item)!
        let binding = (self[keyPath: path])[index]
        return binding
    }
    
}

public extension Binding {
    func binding<Item>(for item: Item) -> Binding<Item> where Value == Array<Item>, Item: Equatable {
        let index = wrappedValue.firstIndex(of: item)!
        let binding = self[index]
        return binding
    }

    func binding<ElementType, PropertyType>(for item: Value.Element, in path: KeyPath<Binding<ElementType>, Binding<PropertyType>>) -> Binding<PropertyType> where Value == Array<ElementType>, ElementType: Equatable {
        let index = wrappedValue.firstIndex(of: item)!
        let element = self[index]
        let binding = element[keyPath: path]
        return binding
    }

}
