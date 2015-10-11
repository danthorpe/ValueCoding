//
//  ValueCoding.swift
//  ValueCoding
//
//  Created by Daniel Thorpe on 11/10/2015.
//
//

import Foundation

// MARK: - ArchiverType

/**
A generic protocol for classes which can 
archive/unarchive value types.
*/
public protocol ArchiverType {

    typealias ValueType

    /// The value type which is being encoded/decoded
    var value: ValueType { get }

    /// Required initializer receiving the wrapped value type.
    init(_: ValueType)
}

/**
A generic protocol for value types which require
archiving.
*/
public protocol ValueCoding {
    typealias Archiver: ArchiverType
}

// MARK: - Protocol Extensions

extension ArchiverType where ValueType: ValueCoding, ValueType.Archiver == Self {

    internal static func unarchive(object: AnyObject?) -> ValueType? {
        return (object as? Self)?.value
    }

    internal static func unarchive<S: SequenceType where S.Generator.Element: AnyObject>(objects: S?) -> [ValueType] {
        return objects?.flatMap(unarchive) ?? []
    }
}

extension SequenceType
    where
    Generator.Element: ArchiverType {

    /// Access the values from a sequence of archives.
    public var values: [Generator.Element.ValueType] {
        return map { $0.value }
    }
}

/**
Default implementations for archiving and unarchiving, instances or sequences
of instances of the ValueCoding types.
*/
extension ValueCoding where Archiver: NSCoding, Archiver.ValueType == Self {

    /**
    Unarchives the value from a single archive, if possible.
    For example

        let foo = Foo.unarchive(decoder.decodeObjectForKey("foo"))

    - parameter object: an optional `AnyObject` which if not nil should
    be of `Archiver` type.
    - returns: an optional `Self`
    */
    public static func unarchive(object: AnyObject?) -> Self? {
        return Archiver.unarchive(object)
    }

    /**
    Unarchives the values from a sequence of archives, if possible
    For example

        let foos = Foo.unarchive(decoder.decodeObjectForKey("foos") as? [AnyObject])
    
    - parameter objects: a `SequenceType` of `AnyObject`.
    - returns: the array of values which were able to be unarchived.
    */
    public static func unarchive<S: SequenceType where S.Generator.Element: AnyObject>(objects: S?) -> [Self] {
        return Archiver.unarchive(objects)
    }

    /**
    Creates an archive for the value type. 
    
    Typically this would be used inside of 
    `encodeWithCoder:` when the value is composed inside
    another `ValueCoding` or `NSCoding` type. For example:
    
        encoder.encodeObject(foo.archive, forKey: "foo")

    */
    public var archive: Archiver {
        return Archiver(self)
    }
}

extension SequenceType
    where
    Generator.Element: ValueCoding,
    Generator.Element.Archiver: NSCoding,
    Generator.Element.Archiver.ValueType == Generator.Element {

    /**
    Access the archives from a sequence of values.

    Typically this would be used inside of
    `encodeWithCoder:` when a sequence of values is
    composed inside another `ValueCoding` or 
    `NSCoding` type. For example:

        encoder.encodeObject(foos.archives, forKey: "foos")

    */
    public var archive: [Generator.Element.Archiver] {
        return map { $0.archive }
    }
}




