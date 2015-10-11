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

    required init(_ v: Foo) {
        value = v
    }

    required init?(coder aDecoder: NSCoder) {
        let bar = aDecoder.decodeObjectForKey(Keys.Bar.rawValue) as? String
        value = Foo(bar: bar!)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value.bar, forKey: Keys.Bar.rawValue)
    }
}

extension Foo: Equatable { }

func ==(a: Foo, b: Foo) -> Bool {
    return a.bar == b.bar
}

