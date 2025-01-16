# Ext: KechainWrapper convenient extension
- **shortcut**: `ext_KeychainWrapper`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
// MARK: - Keychain Access

protocol KeychainCompatible: Codable {}

extension Data: KeychainCompatible {}
extension String: KeychainCompatible {}
extension Double: KeychainCompatible {}
extension Bool: KeychainCompatible {}
extension Int: KeychainCompatible {}
extension Array: KeychainCompatible where Self: Codable {}

extension KeychainWrapper {
    // MARK: KeychainCompatible
    
    subscript<K,V>(_ key: K) -> V? where K: RawRepresentable, K.RawValue == String, V: KeychainCompatible {
        get { value(for: key) }
        set { set(value: newValue, for: key) }
    }
    
    private func value<K,V>(
        for key: K,
        withAccessibility accessibility: KeychainItemAccessibility = .afterFirstUnlockThisDeviceOnly
    ) -> V? where K: RawRepresentable, K.RawValue == String, V: KeychainCompatible {
        let resultType = V.self
        if resultType is String.Type {
            return string(forKey: key.rawValue, withAccessibility: accessibility) as? V
        } else if resultType is Bool.Type {
            return bool(forKey: key.rawValue, withAccessibility: accessibility) as? V
        } else if resultType is Int.Type {
            return integer(forKey: key.rawValue, withAccessibility: accessibility) as? V
        } else if resultType is Double.Type {
            return double(forKey: key.rawValue, withAccessibility: accessibility) as? V
        } else if resultType is Data.Type {
            return data(forKey: key.rawValue, withAccessibility: accessibility) as? V
        } else {
            guard let data: Data = data(forKey: key.rawValue, withAccessibility: accessibility),
                  let value = try? JSONDecoder().decode(V.self, from: data) else {
                return nil
            }
            return value
        }
    }
    
    private func set<K>(
        value newValue: KeychainCompatible?,
        for key: K,
        withAccessibility accessibility: KeychainItemAccessibility = .afterFirstUnlockThisDeviceOnly
    ) where K: RawRepresentable, K.RawValue == String {
        guard let newValue else {
            removeObject(forKey: key.rawValue, withAccessibility: accessibility)
            return
        }
        if let convertedValue = newValue as? Data {
            set(convertedValue, forKey: key.rawValue, withAccessibility: accessibility)
        } else if let convertedValue = newValue as? String {
            set(convertedValue, forKey: key.rawValue, withAccessibility: accessibility)
        } else if let convertedValue = newValue as? Double {
            set(convertedValue, forKey: key.rawValue, withAccessibility: accessibility)
        } else if let convertedValue = newValue as? Bool {
            set(convertedValue, forKey: key.rawValue, withAccessibility: accessibility)
        } else if let convertedValue = newValue as? Int {
            set(convertedValue, forKey: key.rawValue, withAccessibility: accessibility)
        } else {
            guard let encodedData = try? JSONEncoder().encode(newValue) else { return }
            set(encodedData, forKey: key.rawValue, withAccessibility: accessibility)
        }
    }
    
    // MARK: RawRepresentable
    
    subscript<K,V>(_ key: K) -> V? where K: RawRepresentable, K.RawValue == String, V: RawRepresentable, V.RawValue: KeychainCompatible {
        get { value(for: key) }
        set { set(value: newValue, for: key) }
    }
    
    private func value<K,V>(
        for key: K,
        withAccessibility accessibility: KeychainItemAccessibility = .afterFirstUnlockThisDeviceOnly
    ) -> V? where K: RawRepresentable, K.RawValue == String, V: RawRepresentable, V.RawValue: KeychainCompatible {
        guard let value: V.RawValue = value(for: key, withAccessibility: accessibility) else {
            return nil
        }
        return V.init(rawValue: value)
    }
    
    private func set<K,V>(
        value newValue: V?,
        for key: K,
        withAccessibility accessibility: KeychainItemAccessibility = .afterFirstUnlockThisDeviceOnly
    ) where K: RawRepresentable, K.RawValue == String, V: RawRepresentable, V.RawValue: KeychainCompatible {
        set(value: newValue?.rawValue, for: key, withAccessibility: accessibility)
    }
}

```