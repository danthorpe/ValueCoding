//
// ValueCoding
// File created on 11/10/2015.
//
// Copyright (c) 2015-2017 Daniel Thorpe
//
// ValueCoding is licensed under the MIT License. Read the full license at
// https://github.com/danthorpe/ValueCoding/blob/master/LICENSE
//

import Foundation
import ValueCoding

struct Foo: ValueCoding {
    typealias Coder = FooCoder
    let bar: String
}

class FooCoder: NSObject, NSCoding, CodingProtocol {

    enum Keys: String {
        case bar
    }

    let value: Foo

    required init(_ aValue: Foo) {
        value = aValue
    }

    required init?(coder aDecoder: NSCoder) {
        let bar = aDecoder.decodeObject(forKey: Keys.bar.rawValue) as? String
        value = Foo(bar: bar!)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(value.bar, forKey: Keys.bar.rawValue)
    }
}

extension Foo: Equatable { }

func == (lhs: Foo, rhs: Foo) -> Bool {
    return lhs.bar == rhs.bar
}

struct Baz: ValueCoding {
    typealias Coder = BazCoder
    let bat: String
}

extension Baz: Equatable { }

func == (lhs: Baz, rhs: Baz) -> Bool {
    return lhs.bat == rhs.bat
}

class BazCoder: NSObject, NSCoding, CodingProtocol {

    enum Keys: String {
        case baz
    }

    let value: Baz

    required init(_ aValue: Baz) {
        value = aValue
    }

    required init?(coder aDecoder: NSCoder) {
        let bat = aDecoder.decodeObject(forKey: Keys.baz.rawValue) as? String
        value = Baz(bat: bat!)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(value.bat, forKey: Keys.baz.rawValue)
    }
}
