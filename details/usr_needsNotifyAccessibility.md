# Accessibility: Notification
- **shortcut**: `usr_needsNotifyAccessibility`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
    // MARK: - Accessibility

    private func setNeedsNotifyAccessibilityLayoutChanged(view: UIView?) {
        setNeedsNotifyAcessibility(notification: .layoutChanged, argument: view)
    }

    private func setNeedsNotifyAccessibilityScreenChanged(view: UIView?) {
        setNeedsNotifyAcessibility(notification: .screenChanged, argument: view)
    }

    private var needsNotifyAccessibility = false

    private func setNeedsNotifyAcessibility(notification: UIAccessibility.Notification, argument: Any?) {
        if UIAccessibility.isVoiceOverRunning && !needsNotifyAccessibility {
            needsNotifyAccessibility = true
            DispatchQueue.main.async { [weak self] in
                if let needsUpdate = self?.needsNotifyAccessibility, needsUpdate {
                    self?.needsNotifyAccessibility = false
                    UIAccessibility.post(notification: notification, argument: argument)
                }
            }
        }
    }
```