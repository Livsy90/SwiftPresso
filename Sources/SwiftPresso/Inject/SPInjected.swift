import Foundation

@propertyWrapper
public struct SPProvider<T> {
    
    public var wrappedValue: T {
        get {
            guard !SPConfigurator.shared.configuration.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SPConfigurator.shared.configuration' value.")
            }
            return InjectedValues[keyPath]
        }
        set {
            InjectedValues[keyPath] = newValue
        }
    }
    
    private let keyPath: WritableKeyPath<InjectedValues, T>
    
    public init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
    
}

protocol InjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}

public struct InjectedValues {
    
    private static var current = InjectedValues()
    
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get {
            key.currentValue
        }
        set {
            key.currentValue = newValue
        }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get {
            current[keyPath: keyPath]
        }
        set {
            current[keyPath: keyPath] = newValue
        }
    }
    
}
