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

// MARK: - CodingProtocol

public protocol CodedValue {

    /**
     The type of the composed value, Value

     - see: ValueCoding
     */
    associatedtype Value

    /// The value type which was coded
    var value: Value { get }
}

/**
A generic protocol for classes which can
encode/decode value types.
*/
public protocol CodingProtocol: CodedValue {

    /// Required initializer receiving the wrapped value type.
    init(_: Value)
}

// MARK: - ValueCoding

/**
A generic protocol for value types which require
coding.
*/
public protocol ValueCoding {

    /**
     The Coder which implements CodingProtocol

     - see: CodingProtocol
    */
    associatedtype Coder: CodingProtocol
}

// MARK: - Protocol Extensions

public extension Sequence where Iterator.Element: CodingProtocol {

    /// Access the values from a sequence of coders.
    var values: [Iterator.Element.Value] {
        return map { $0.value }
    }
}

/**
Static methods for decoding `AnyObject` to Self, and returning encoded object
of Self.
*/
public extension ValueCoding where Coder: NSCoding, Coder.Value == Self {

    /**
    Decodes the value from a single decoder, if possible.
    For example

        let foo = Foo.decode(decoder.decodeObjectForKey("foo"))

    - parameter object: an optional `AnyObject` which if not nil should
    be of `Coder` type.
    - returns: an optional `Self`
    */
    static func decode(_ object: Any?) -> Self? {
        return (object as? Coder)?.value
    }

    /**
    Decodes the values from a sequence of coders, if possible
    For example

        let foos = Foo.decode(decoder.decodeObjectForKey("foos") as? [AnyObject])

    - parameter objects: a `SequenceType` of `AnyObject`.
    - returns: the array of values which were able to be unarchived.
    */
    static func decode<S: Sequence>(_ objects: S?) -> [Self] where S.Iterator.Element: Any {
        return objects?.flatMap(Self.decode) ?? []
    }

    /**
     Decodes the values from a sequence of sequence of coders, if possible

     - parameter objects: a `SequenceType` of `SequenceType` of `AnyObject`.
     - returns: the array of arrays of values which were able to be unarchived.
     */
    static func decode<S: Sequence>(_ objects: S?) -> [[Self]] where S.Iterator.Element: Sequence, S.Iterator.Element.Iterator.Element: Any {
        return objects?.flatMap(Self.decode) ?? []
    }

    /**
    Encodes the value type into its Coder.

    Typically this would be used inside of
    `encodeWithCoder:` when the value is composed inside
    another `ValueCoding` or `NSCoding` type. For example:

        encoder.encodeObject(foo.encoded, forKey: "foo")

    */
    var encoded: Coder {
        return Coder(self)
    }
}

extension Sequence where
    Iterator.Element: ValueCoding,
    Iterator.Element.Coder: NSCoding,
    Iterator.Element.Coder.Value == Iterator.Element {

    /**
    Encodes the sequence of value types into an array of coders.

    Typically this would be used inside of
    `encodeWithCoder:` when a sequence of values is
    composed inside another `ValueCoding` or
    `NSCoding` type. For example:

        encoder.encodeObject(foos.encoded, forKey: "foos")

    */
    public var encoded: [Iterator.Element.Coder] {
        return map { $0.encoded }
    }
}

extension Sequence where
    Iterator.Element: Sequence,
    Iterator.Element.Iterator.Element: ValueCoding,
    Iterator.Element.Iterator.Element.Coder: NSCoding,
    Iterator.Element.Iterator.Element.Coder.Value == Iterator.Element.Iterator.Element {

    /**
     Encodes a sequence of sequences of value types into
     an array of arrays of coders.
     */
    public var encoded: [[Iterator.Element.Iterator.Element.Coder]] {
        return map { $0.encoded }
    }
}
