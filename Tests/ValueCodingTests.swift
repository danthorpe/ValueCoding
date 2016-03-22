//
//  ValueCodingTests.swift
//  ValueCoding
//
//  Created by Daniel Thorpe on 11/10/2015.
//
//

import Foundation
import XCTest
@testable import ValueCoding


class ValueCodingTests: XCTestCase {

    var item: Foo!
    var items: [Foo]!
    var nested: [[Foo]]!

    override func setUp() {
        super.setUp()
        createFoos()
    }

    override func tearDown() {
        item = nil
        items = nil
        super.tearDown()
    }

    func createFoos() {
        item = Foo(bar: "Hello World")
        items = [
            item,
            Foo(bar: "Hola mundo"),
            Foo(bar: "Bonjour le monde"),
            Foo(bar: "Hallo Welt"),
            Foo(bar: "हैलो वर्ल्ड"),
            Foo(bar: "こんにちは世界"),
        ]
        nested = [
            items
        ]
    }

    func test__single_archiving() {
        let unarchived = Foo.decode(item.encoded)
        XCTAssertNotNil(unarchived)
        XCTAssertEqual(unarchived!, item)
    }

    func test__multiple_archiving() {
        let unarchived = Foo.decode(items.encoded)
        XCTAssertEqual(unarchived, items)
    }

    func test__nested_archiving() {
        let unarchived = Foo.decode(nested.encoded)
        XCTAssertEqual(unarchived.count, 1)
        XCTAssertEqual(unarchived[0], nested[0])
    }

    func test__with_single_nil() {
        let empty: AnyObject? = .None
        XCTAssertNil(Foo.decode(empty))
    }

    func test__with_sequence_nil() {
        let empty: [AnyObject]? = .None
        XCTAssertTrue(Foo.decode(empty).isEmpty)
    }

    func test__with_nested_nil() {
        let empty: [[AnyObject]]? = .None
        XCTAssertTrue(Foo.decode(empty).isEmpty)
    }

    func test__get_values_from_sequence_of_archivers() {
        XCTAssertEqual(items.encoded.values, items)
    }
}
