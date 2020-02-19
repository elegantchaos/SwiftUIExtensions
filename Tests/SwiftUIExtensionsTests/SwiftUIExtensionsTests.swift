import XCTest
import SwiftUI

@testable import SwiftUIExtensions

class TestItem: ObservableObject, Equatable {
    @Published var value: String
    
    init(_ value: String) {
        self.value = value
    }

    static func == (lhs: TestItem, rhs: TestItem) -> Bool {
        return lhs.value == rhs.value
    }
    
}

class TestObject: ObservableObject {
    @Published var items: [TestItem]
    
    init(items: [TestItem]) {
        self.items = items
    }
}


final class SwiftUIExtensionsTests: XCTestCase {
    @ObservedObject var exampleObject: TestObject = TestObject(items: [TestItem("Foo"), TestItem("Bar")])
    @State var exampleArray: [TestItem] = [TestItem("Foo"), TestItem("Bar")]
    
    func testBindingForArrayProperty() {
        for item in exampleObject.items {
            let binding = $exampleObject.binding(for: item, in: \.items)
            XCTAssertTrue(binding.wrappedValue == item)
        }
    }

    func testBindingForArrayItem() {
        for item in exampleArray {
            let binding = $exampleArray.binding(for: item)
            XCTAssertTrue(binding.wrappedValue == item)
        }
    }

    func testBindingForPropertyOfArrayItem() {
        for item in exampleArray {
            let binding = $exampleArray.binding(for: \.value, of: item)
            XCTAssertTrue(binding.wrappedValue == item.value)
        }
    }
}
