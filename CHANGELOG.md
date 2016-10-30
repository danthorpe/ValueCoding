# 2.1.0
This is for Xcode 8.1, Swift 3.0.1

# 2.0.0
This is the Swift 3.0 compatible version.

The key change here is that `CodingType` has been renamed to `CodingProtocol` in accordance with Swift 3.0 naming style.

# 1.5.0
This is a Swift 2.3 compatible version

# 1.4.0
1. [[VCD-19](https://github.com/danthorpe/ValueCoding/pull/19)]: Recreates the project to use a single multi-platform framework target.

# 1.3.0
1. [[VCD-13](https://github.com/danthorpe/ValueCoding/pull/13)]: Switches test coverage reporting to Coveralls. Also adds SwiftLint rules into the project and CI.
2. [[VCD-14](https://github.com/danthorpe/ValueCoding/pull/14)]: Updates to Swift 2.2 syntax. :)

# 1.2.0
1. [[VCD-9, VCD-10](https://github.com/danthorpe/ValueCoding/pull/10)]: Adds support for a single level of nesting inside SequenceType values. For example it is now possible to encode and decode `[[Foo]]` structures where `Foo` conforms to `ValueCoding`.
 
# 1.1.1
1. [[VCD-7](https://github.com/danthorpe/ValueCoding/pull/7)]: Updates CI stuff.
2. [[VCD-8](https://github.com/danthorpe/ValueCoding/pull/8)]: Updates documentation and README. Thanks [@mrackwitz](https://github.com/danthorpe/ValueCoding/commit/489809da1ba70abf09bc519b784d77a3c47b9f41).

# 1.1.0
1. [[VCD-4](https://github.com/danthorpe/ValueCoding/pull/4)]: Supports tvOS platform, and updates to Xcode 7.1

# 1.0.1
1. [[VCD-1](https://github.com/danthorpe/ValueCoding/pull/1)]: Sets up cross platform project
2. [[VCD-2](https://github.com/danthorpe/ValueCoding/pull/2)]: Adds podspec
