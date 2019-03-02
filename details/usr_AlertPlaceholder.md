# Placeholder alert
- **shortcut**: `usr_AlertPlaceholder`
- **language**: Swift
- **platform**: iphoneos


## Code:
```swift
let placeholderAlert = UIAlertController(title: "<#title#>",
                                      message: "<#message#>",
                                      preferredStyle: .alert)
        
        placeholderAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        placeholderAlert.present(on: self)
```