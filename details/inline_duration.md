# Inline: Duration with time interval between dates
- **shortcut**: `inline_duration`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
        let duration = Duration
            .seconds(Date().timeIntervalSince(date))
            .formatted(.units(
                allowed: [.minutes, .seconds, .milliseconds],
                width: .condensedAbbreviated
                //,fractionalPart: .show(length: 3) // uncomment if you need miliseconds as a decimal.
            ))
```