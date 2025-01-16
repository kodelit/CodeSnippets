# Tests: Mock method with 2 params, returning value
- **shortcut**: `test_mockMethod_2Params_ReturningValue`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
private(set) var <#name#>Counter: Int = 0
private(set) var <#name#>Parameters: (<#FirstType#>, <#SecondType#>)?
/// - warning: Property is forcefully unwrap in order to prevent false positives. expect test crash when value is not set but is used in test.
var <#name#>MockedResponse: <#ReturnType#>!
func <#name#>(_ first: <#FirstType#>, _ second: <#SecondType#>) -> <#ReturnType#> {
    <#name#>Counter += 1
    <#name#>Parameters = (first, second)
    return <#name#>MockedResponse
}
```