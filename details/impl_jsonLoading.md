# Impl: Loading with JSON
- **shortcut**: `impl_jsonLoading`
- **language**: Swift
- **platform**: 

## Summary


## Code:
```swift
    /// Loads Quiz with the JSON file name in the bundle.
    /// - Parameters:
    ///   - fileName: resource file name without extension.
    ///   - bundle: default is `Bundle.main`.
    /// - Returns: Instance of the model loaded with the JSON resource file in the bundle.
    static func loadWithJSON<T>(fileName: String, bundle: Bundle = .main, decoder: JSONDecoder = GearManagement.jsonDecoder) -> T? where T: Decodable {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            assertionFailure("No JSON with file name: \(fileName) in bundle: \(bundle.bundleIdentifier ?? "") ")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch {
            print("Failed to load JSON: \(fileName) from bundle: \(bundle.bundleIdentifier ?? ""), error:", error)
        }
        return nil
    }

    @available(macOS 10.11, *)
    static func loadWithJSON<T>(dataAssetName name: String, bundle: Bundle = .main, decoder: JSONDecoder = GearManagement.jsonDecoder) -> T? where T: Decodable {
        guard let asset = NSDataAsset(name: name, bundle: bundle) else {
            assertionFailure("No Asset with name: \(name) in bundle: \(bundle.bundleIdentifier ?? "") ")
            return nil
        }

        do {
            let data = asset.data
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch {
            print("Failed to load from JSON Asset: \(name) in bundle: \(bundle.bundleIdentifier ?? ""), error:", error)
        }
        return nil
    }
```