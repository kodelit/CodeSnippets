# Tests: Mock method with 1 param, returning value
- **shortcut**: `test_mockMethod_1Param_ReturningValue`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
    private(set) var <#name#>Counter: Int = 0
    private(set) var <#name#>Parameters: <#ParamType#>?
    /// - warning: Property is forcefully unwrap in order to prevent false positives. expect test crash when value is not set but is used in test.
    var <#name#>MockedResponse: <#ReturnType#>!
    func <#name#>(_ param: <#ParamType#>) -> <#ReturnType#> {
        <#name#>Counter += 1
        <#name#>Parameters = param
        return <#name#>MockedResponse
    }
```