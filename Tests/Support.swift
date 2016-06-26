//
//  Support.swift
//  ValueCoding
//
//  Created by Daniel Thorpe on 11/10/2015.
//
//

import Foundation
import ValueCoding

struct Foo: ValueCoding {
    typealias Coder = FooCoder
    let bar: String
}

class FooCoder: NSObject, NSCoding, CodingType {

    enum Keys: String {
        case Bar = "bar"
    }

    let value: Foo

    required init(_ aValue: Foo) {
        value = aValue
    }

    required init?(coder aDecoder: NSCoder) {
        let bar = aDecoder.decodeObject(forKey: Keys.Bar.rawValue) as? String
        value = Foo(bar: bar!)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(value.bar, forKey: Keys.Bar.rawValue)
    }
}

extension Foo: Equatable { }

func == (lhs: Foo, rhs: Foo) -> Bool {
    return lhs.bar == rhs.bar
}
