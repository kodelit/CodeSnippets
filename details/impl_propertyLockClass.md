# Impl: Class with property lock
- **shortcut**: `impl_propertyLockClass`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
// - source: https://forums.swift.org/t/preventing-regressions-when-conforming-to-sendable-with-unchecked/62137/4

final class CustomClass: @unchecked Sendable {
    private var _property: Int = 0
    private var propertyLock = NSLock()
    func withProperty(_ operation: (inout Int) -> Void) {
        propertyLock.lock()
        defer { propertyLock.unlock() }
        operation(&_property)
    }
}

//@Test func raceCondition() async {
//    let object = CustomClass()
//    await withTaskGroup(of: Void.self) { group in
//        for _ in 1...10_000 {
//            group.addTask { object.withProperty { $0 += 1 } }
//        }
//    }
//    #expect(object.property == 10_000)  // ✅
//}
```