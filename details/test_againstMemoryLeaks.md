# Test: Against Memory Leaks
- **shortcut**: `test_againstMemoryLeaks`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
typealias Sut = <#TypeName#>
    
    func createSut() -> Sut {
        let sut = <#TypeName#>()
        return sut
    }
    
    func test_againstMemoryLeaks() {
        // given
        var sut: Sut? = createSut()
        weak var weakSut = sut
        
        // when
        sut = nil
        
        // then
        XCTAssertNil(weakSut)
    }
```