# Backup: PayeeEvent
- **shortcut**: `backup_payeeEvent`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
import Foundation

enum BeneficiaryMatchingEventId: Int {
    case unknown = -1
    case accountNameNoMatch = 3216
    case accountNameMayMatch = 3217
    case businessAccountNameMatch = 3218
    case personalAccountNameMatch = 3219
    case businessAccountNameMayMatch = 3220
    case personalAccountNameMayMatch = 3221
    case incorrectAccountName = 3222
    case invalidCustomReference = 3223
    case accountTypeNotSupported = 3224
    case accountHasBeenSwitched = 3225
    case ibanNotSupported = 3226
    case secondaryReferenceDataRequired = 3227
    case accountOptedOutCop = 3228
    case serviceUnavailableFailedCopCall = 3230
    case confirmationOfPayeeMatched = 3231
    case serviceUnavailableCopCallValidationFailed = 3232
    case serviceUnavailable = 3233
}

struct BeneficiaryMatchingEventCopies: Hashable, CaseIterable {
    let eventId: BeneficiaryMatchingEventId
    let title: String
    let description: String
    
    var isFullyMatched: Bool {
        self == .confirmationOfPayeeMatched
    }
    
    init(eventId: BeneficiaryMatchingEventId, title: String, description: String) {
        self.eventId = eventId
        self.title = title
        self.description = description
    }
    
    init?(eventId: BeneficiaryMatchingEventId) {
        guard let details = Self.allCases.first(where: { eventId == $0.eventId }) else {
            return nil
        }
        self = details
    }
    
    static var allCases: [BeneficiaryMatchingEventCopies] = [
        unknown,
        accountNameNoMatch,
        accountNameMayMatch,
        businessAccountNameMatch,
        personalAccountNameMatch,
        businessAccountNameMayMatch,
        personalAccountNameMayMatch,
        incorrectAccountName,
        invalidCustomReference,
        accountTypeNotSupported,
        accountHasBeenSwitched,
        ibanNotSupported,
        secondaryReferenceDataRequired,
        accountOptedOutCop,
        serviceUnavailableFailedCopCall,
        confirmationOfPayeeMatched,
        serviceUnavailableCopCallValidationFailed,
        serviceUnavailable
    ]
}

// MARK: - Predefined Copies

extension BeneficiaryMatchingEventCopies {
    static let unknown = Self(
        eventId: .unknown,
        title: "serviceUnavailableTitle".localizedText(),
        description: "serviceUnavailableDescription".localizedText()
    )
    
    static let accountNameNoMatch = Self(
        eventId: .accountNameNoMatch,
        title: "accountNameNoMatchTitle".localizedText(),
        description: "accountNameNoMatchDescription".localizedText()
    )
    
    static let accountNameMayMatch = Self(
        eventId: .accountNameMayMatch,
        title: "accountNameMayMatchTitle".localizedText(),
        description: "accountNameMayMatchDescription".localizedText()
    )
    
    static let businessAccountNameMatch = Self(
        eventId: .businessAccountNameMatch,
        title: "businessAccountNameMatchTitle".localizedText(),
        description: "businessAccountNameMatchDescription".localizedText()
    )
    
    static let personalAccountNameMatch = Self(
        eventId: .personalAccountNameMatch,
        title: "personalAccountNameMatchTitle".localizedText(),
        description: "personalAccountNameMatchDescription".localizedText()
    )
    
    static let businessAccountNameMayMatch = Self(
        eventId: .businessAccountNameMayMatch,
        title: "businessAccountNameMayMatchTitle".localizedText(),
        description: "businessAccountNameMayMatchDescription".localizedText()
    )
    
    static let personalAccountNameMayMatch = Self(
        eventId: .personalAccountNameMayMatch,
        title: "personalAccountNameMayMatchTitle".localizedText(),
        description: "personalAccountNameMayMatchDescription".localizedText()
    )
    
    static let incorrectAccountName = Self(
        eventId: .incorrectAccountName,
        title: "incorrectAccountNameTitle".localizedText(),
        description: "incorrectAccountNameDescription".localizedText()
    )
    
    static let invalidCustomReference = Self(
        eventId: .invalidCustomReference,
        title: "invalidCustomReferenceTitle".localizedText(),
        description: "invalidCustomReferenceDescription".localizedText()
    )
    
    static let accountTypeNotSupported = Self(
        eventId: .accountTypeNotSupported,
        title: "accountTypeNotSupportedTitle".localizedText(),
        description: "accountTypeNotSupportedDescription".localizedText()
    )
    
    static let accountHasBeenSwitched = Self(
        eventId: .accountHasBeenSwitched,
        title: "accountHasBeenSwitchedTitle".localizedText(),
        description: "accountHasBeenSwitchedDescription".localizedText()
    )
    
    static let ibanNotSupported = Self(
        eventId: .ibanNotSupported,
        title: "ibanNotSupportedTitle".localizedText(),
        description: "ibanNotSupportedDescription".localizedText()
    )
    
    static let secondaryReferenceDataRequired = Self(
        eventId: .secondaryReferenceDataRequired,
        title: "secondaryReferenceDataRequiredTitle".localizedText(),
        description: "secondaryReferenceDataRequiredDescription".localizedText()
    )
    
    static let accountOptedOutCop = Self(
        eventId: .accountOptedOutCop,
        title: "accountOptedOutCopTitle".localizedText(),
        description: "accountOptedOutCopDescription".localizedText()
    )
    
    static let serviceUnavailableFailedCopCall = Self(
        eventId: .serviceUnavailableFailedCopCall,
        title: "serviceUnavailableTitle".localizedText(),
        description: "serviceUnavailableDescription".localizedText()
    )
    
    static let confirmationOfPayeeMatched = Self(
        eventId: .confirmationOfPayeeMatched,
        title: "confirmationOfPayeeMatchedTitle".localizedText(),
        description: "secondaryReferenceDataRequiredDescription".localizedText()
    )
    
    static let serviceUnavailableCopCallValidationFailed = Self(
        eventId: .serviceUnavailableCopCallValidationFailed,
        title: "serviceUnavailableTitle".localizedText(),
        description: "serviceUnavailableDescription".localizedText()
    )
    
    static let serviceUnavailable = Self(
        eventId: .serviceUnavailable,
        title: "serviceUnavailableTitle".localizedText(),
        description: "serviceUnavailableDescription".localizedText()
    )
}
```