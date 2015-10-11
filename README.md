# ValueCoding

[![Build status](https://badge.buildkite.com/482fd5558d9ccf05b669c55f40450166033522f32314a1bbb2.svg)](https://buildkite.com/blindingskies/valuecoding)

ValueCoding is a simple pair of protocols to support the archiving and unarchiving of Swift value types.

It works by allowing a value type, which must conform to `ValueCoding` to define via a typealias its *archiver*. The archiver is another type which implements the `ArchiverType` protocol. This type will typically be an `NSObject` which implements `NSCoding` and is an adaptor which is responsible for encoding and decoding the properties of the value.

A minimal example for a simple `struct` is shown below:

```swift
import ValueCoding

struct Foo: ValueCoding {
    typealias Archiver = FooArchiver
    let bar: String
}

class FooArchiver: NSObject, NSCoding, ArchiverType {

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
```

If you are converting existing models from classes to values types, the `NSCoding` methods should look familiar, and hopefully you are able to reuse your existing code.

The framework provides static methods and properties for types which conform to `ValueCoding` with correct archivers. Therefore, given a value of `Foo`, you can get an archive ready for serialization using `NSKeyedArchiver`.

```swift
let data = NSKeyedArchiver.archivedDataWithRootObject(foo.archive)
```

and likewise, unarchiving can be done:

```swift
if let foo = Foo.unarchive(NSKeyedUnarchiver.unarchiveObjectWithData(data)) {
    // etc, unarchive always returns optionals.
}
```

These methods can also be used if composing value types inside other types which require encoding.

When working with sequences of values, use the `archives` property.

```swift
let foos = Set(arrayLiteral: Foo(), Foo(), Foo())
let data = NSKeyedArchiver.archivedDataWithRootObject(foos.archive)
```

When unarchiving an `NSArray`, perform a conditional cast to `[AnyObject]` before passing it to `unarchive`. The result will be an `Array<Foo>` which will be empty if the object was not cast successfully. In addition, any members of `[AnyObject]` which did not unarchive will filtered from the result. This means that the length of the result will be less than the original archived array if there was an issue decoding.

```swift
let foos = Foo.unarchive(NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject])
```


