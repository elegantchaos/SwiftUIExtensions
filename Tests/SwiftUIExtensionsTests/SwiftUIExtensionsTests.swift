import XCTest
import SwiftUI

@testable import SwiftUIExtensions

class TestObject: ObservableObject {
    @Published var items: [String]
    @Published var property: String
    
    init(items: [String], property: String) {
        self.items = items
        self.property = property
    }
}

struct TestView: View {
    @ObservedObject var exampleObject: TestObject
    
    var body: some View {
        Text("Hello")
    }
}

final class SwiftUIExtensionsTests: XCTestCase {
    func testBindingForArrayProperty() {
        let view = TestView(exampleObject: TestObject(items: ["Foo", "Bar"], property: "Baz"))
        for item in view.exampleObject.items {
            let binding = view.$exampleObject.binding(for: item, in: \.items)
            XCTAssertTrue(binding.wrappedValue == item)
        }
    }

    func testBindingForArrayItem() {
        let view = TestView(exampleObject: TestObject(items: ["Foo", "Bar"], property: "Baz"))
        for item in view.exampleObject.items {
            let binding = view.$exampleObject.binding(for: item, in: \.items)
            XCTAssertTrue(binding.wrappedValue == item)
        }
    }

    finc
}
