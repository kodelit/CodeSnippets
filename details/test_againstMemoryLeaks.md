# Test: Against Memory Leaks
- **shortcut**: `test_againstMemoryLeaks`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
typealias Sut = <#TypeName#>
    
    func loadSut() -> Sut {
        let sut = Sut()
        return sut
    }



    @Test("Basic test against memory leaks")
    func memoryLeaks() async throws {
        // given
        var sut: Sut? = loadSut()
        weak var weakSut = sut

        // when
        sut = nil
        
        // then
        #expect(weakSut == nil)
    }
    
    //func test_againstMemoryLeaks() {
    //    // given
    //    var sut: Sut? = loadSut()
    //    weak var weakSut = sut
    //    
    //    // when
    //    sut = nil
    //    
    //    // then
    //    XCTAssertNil(weakSut)
    //}
```