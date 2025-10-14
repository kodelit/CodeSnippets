# Impl: JSON Data Loading
- **shortcut**: `impl_jsonDataLoader`
- **language**: Swift
- **platform**: 

## Summary
Definition and implementation of JSON data loading protocols supporting loading json form bundle file, string or data.

## Code:
```swift
import Foundation

public enum JsonDataLoadingError: Swift.Error {
    case fileNotFound(fileName: String)
}

// MARK: - Loading model from JSON String or Data

/// JSON data loading protocol.
///
/// Protocol is used in order to enabling dependency incjection and make the implementation replacable.
public protocol JsonDataLoading {
    func loadFrom<T: Decodable>(json: String) throws -> T
    func loadFrom<T: Decodable>(json data: Data) throws -> T
}

public extension JsonDataLoading {
    func loadFrom<T: Decodable>(json: String) throws -> T {
        try T.loadFrom(json: json)
    }

    func loadFrom<T: Decodable>(json data: Data) throws -> T {
        try T.loadFrom(json: data)
    }
}

// MARK: - Loading model from JSON file

/// JSON data loading protocol.
///
/// Protocol is used in order to enabling dependency incjection and make the implementation replacable.
public protocol JsonFileDataLoading {
    func loadFrom<T: Decodable>(jsonFileName: String) throws -> T
}

public struct BundleJsonDataLoader: JsonFileDataLoading {
    public let bundle: Bundle
    public let decoder: JSONDecoder

    public init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    /// Create instance of Decodable type T from the json file with the given name which is embeded in the main Bundle.
    ///
    /// - parameter jsonFileName: JSON file name without extension in the bundle.
    public func loadFrom<T: Decodable>(jsonFileName: String) throws -> T {
        try bundle.loadData(jsonFileName: jsonFileName)
    }
}

// MARK: - Decodable protocol extension for loading model from JSON data

/// - warning: This extension should not be used directly in code but for implementing `JsonFileDataLoading` or `JsonDataLoading` protocol.
/// Implementing these protocols and use them in the app allows to mock, replace and inject their different implementations for different cases.
public extension Decodable {
    /// Loads list of items of type Self from the json file with the given name which is embeded in the main Bundle.
    ///
    /// - parameter bundle: defalut value is `Bundle.main`.
    /// - parameter name: JSON file name without extension in the bundle.
    /// - parameter decoder: default value is default `JSONDecoder()`
    ///
    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    static func loadFrom(bundle: Bundle = .main, jsonFile name: String, decoder: JSONDecoder = JSONDecoder()) throws -> [Self] {
        try Bundle.main.loadData(jsonFileName: name, decoder: decoder) ?? []
    }

    /// Create instance of Self from the json file with the given name which is embeded in the main Bundle.
    ///
    /// - parameter bundle: defalut value is `Bundle.main`.
    /// - parameter name: JSON file name without extension in the bundle.
    /// - parameter decoder: default value is default `JSONDecoder()`
    ///
    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    static func loadFrom(bundle: Bundle = .main, jsonFile name: String, decoder: JSONDecoder = JSONDecoder()) throws -> Self? {
        try Bundle.main.loadData(jsonFileName: name, decoder: decoder)
    }

    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    static func loadFrom(json: String, decoder: JSONDecoder = JSONDecoder()) throws -> [Self] {
        let data = json.data(using: .utf8) ?? Data()
        return try loadFrom(json: data, decoder: decoder)
    }

    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    static func loadFrom(json: String, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        let data = json.data(using: .utf8) ?? Data()
        return try loadFrom(json: data, decoder: decoder)
    }

    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    static func loadFrom(json data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> [Self] {
        try decoder.decode([Self].self, from: data)
    }

    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    static func loadFrom(json data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        try decoder.decode(Self.self, from: data)
    }
}

// MARK: - Bundle extension for loading model from JSON data

public extension Bundle {
    /// - warning: This method should not be used directly in code but only for implementing workers.
    /// In order to support Dependency Injection we need workers which might be mocked, replaced and injected when needed.
    /// Using methods like following, outside the worker implementation makes the code depandant on real types which the method extends and which cannot be mocked making the code less testable.
    func loadData<T: Decodable>(jsonFileName: String, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        if let jsonPath  = self.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
                return try T.loadFrom(json: data, decoder: decoder)
            } catch {
                print("Error occured when loading JSON data from bundle: \(bundleIdentifier ?? "<no identifier>"), fileName: \(jsonFileName), error: \(error)")
                throw error
            }
        }
        throw JsonDataLoadingError.fileNotFound(fileName: jsonFileName)
    }
}

```