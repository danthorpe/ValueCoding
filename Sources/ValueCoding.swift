//
//  ValueCoding.swift
//  ValueCoding
//
//  Created by Daniel Thorpe on 11/10/2015.
//
//

import Foundation

// MARK: - CodingType

/**
A generic protocol for classes which can
encode/decode value types.
*/
public protocol CodingType {

    /**
     The type of the composed value, ValueType

     Bear in mind that there are no constraints on this
     type. However, in reality when working with generic
     types which require coding, it will be necessary to
     constrain your generic clauses like this:

     ```swift
     func foo<T: ValueCoding where T.Coder.ValueType == T>()
     ```

     - see: ValueCoding
    */
    associatedtype ValueType

    /// The value type which is being encoded/decoded
    var value: ValueType { get }

    /// Required initializer receiving the wrapped value type.
    init(_: ValueType)
}

// MARK: - ValueCoding

/**
A generic protocol for value types which require
coding.
*/
public protocol ValueCoding {

    /**
     The Coder which implements CodingType

     - see: CodingType
    */
    associatedtype Coder: CodingType
}

// MARK: - Protocol Extensions



extension CodingType where
    ValueType: ValueCoding,
    ValueType.Coder == Self {

    internal static func decode(_ object: AnyObject?) -> ValueType? {
        return (object as? Self)?.value
    }

    internal static func decode<S: Sequence where S.Iterator.Element: AnyObject>(_ objects: S?) -> [ValueType] {
        return objects?.flatMap(decode) ?? []
    }

    internal static func decode<S: Sequence where S.Iterator.Element: Sequence, S.Iterator.Element.Iterator.Element: AnyObject>(_ objects: S?) -> [[ValueType]] {
        return objects?.flatMap(decode) ?? []
    }
}

extension Sequence where
    Iterator.Element: CodingType {

    /// Access the values from a sequence of coders.
    public var values: [Iterator.Element.ValueType] {
        return map { $0.value }
    }
}

/**
Static methods for decoding `AnyObject` to Self, and returning encoded object
of Self.
*/
extension ValueCoding where Coder: NSCoding, Coder.ValueType == Self {

    /**
    Decodes the value from a single decoder, if possible.
    For example

        let foo = Foo.decode(decoder.decodeObjectForKey("foo"))

    - parameter object: an optional `AnyObject` which if not nil should
    be of `Coder` type.
    - returns: an optional `Self`
    */
    public static func decode(_ object: AnyObject?) -> Self? {
        return Coder.decode(object)
    }

    /**
    Decodes the values from a sequence of coders, if possible
    For example

        let foos = Foo.decode(decoder.decodeObjectForKey("foos") as? [AnyObject])

    - parameter objects: a `SequenceType` of `AnyObject`.
    - returns: the array of values which were able to be unarchived.
    */
    public static func decode<S: Sequence where S.Iterator.Element: AnyObject>(_ objects: S?) -> [Self] {
        return Coder.decode(objects)
    }

    /**
     Decodes the values from a sequence of sequence of coders, if possible

     - parameter objects: a `SequenceType` of `SequenceType` of `AnyObject`.
     - returns: the array of arrays of values which were able to be unarchived.
     */
    public static func decode<S: Sequence where S.Iterator.Element: Sequence, S.Iterator.Element.Iterator.Element: AnyObject>(_ objects: S?) -> [[Self]] {
        return Coder.decode(objects)
    }

    /**
    Encodes the value type into its Coder.

    Typically this would be used inside of
    `encodeWithCoder:` when the value is composed inside
    another `ValueCoding` or `NSCoding` type. For example:

        encoder.encodeObject(foo.encoded, forKey: "foo")

    */
    public var encoded: Coder {
        return Coder(self)
    }
}

extension Sequence where
    Iterator.Element: ValueCoding,
    Iterator.Element.Coder: NSCoding,
    Iterator.Element.Coder.ValueType == Iterator.Element {

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
    Iterator.Element.Iterator.Element.Coder.ValueType == Iterator.Element.Iterator.Element {

    /**
     Encodes a sequence of sequences of value types into
     an array of arrays of coders.
     */
    public var encoded: [[Iterator.Element.Iterator.Element.Coder]] {
        return map { $0.encoded }
    }
}
