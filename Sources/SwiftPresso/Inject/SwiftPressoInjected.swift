import Foundation

@propertyWrapper
public struct SwiftPressoInjected<T> {
    
    public var wrappedValue: T {
        get {
            SwiftPressoInjectedValues[keyPath]
        }
        set {
            SwiftPressoInjectedValues[keyPath] = newValue
        }
    }
    
    private let keyPath: WritableKeyPath<SwiftPressoInjectedValues, T>
    
    public init(_ keyPath: WritableKeyPath<SwiftPressoInjectedValues, T>) {
        self.keyPath = keyPath
    }
    
}
