# Ext: BannerPresenting
- **shortcut**: `ext_BannerPresenting`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
protocol <#NotificationName#>Presenting {
    var actionViewContainer: BannerViewContainer! { get }
    func setup<#NotificationName#>View()
    func set<#NotificationName#>ViewVisible(_ visible: Bool, animated: Bool)
}

private let <#notificationName#>ViewKey = "<#notificationName#>View"

extension <#NotificationName#>Presenting {
    var <#notificationName#>View: TextViewWithActionView {
        actionViewContainer[<#notificationName#>ViewKey] as? TextViewWithActionView ?? add<#NotificationName#>View()
    }

    func setup<#NotificationName#>View() {}

    func set<#NotificationName#>ViewVisible(_ visible: Bool, animated: Bool) {
        <#notificationName#>View.setMinimized(visible, animated: animated)
    }

    @discardableResult
    private func add<#NotificationName#>View() -> TextViewWithActionView {
        let view = TextViewWithActionView.loadFromBundle()
        view.setupTextViewWithAction(messageText: LocalizedStrings.Inbox.accountInactiveTitle,
                                                    actionText: LocalizedStrings.Inbox.accountInactiveAction,
                                                    accessibilityActionDescription: LocalizedStrings.Inbox.accountInactiveAccessibilityAction)
        view.alertImageIsHidden = false
        view.viewAlignment = .left
        //view.textFontStyle = DefaultFontStyle.inboxSentActivityText
        actionViewContainer[<#notificationName#>ViewKey] = view
        setup<#NotificationName#>View()
        return view
    }
}
```