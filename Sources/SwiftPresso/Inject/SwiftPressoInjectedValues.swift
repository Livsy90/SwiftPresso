public struct SwiftPressoInjectedValues {
    
    private static var current = SwiftPressoInjectedValues()
    
    static subscript<K>(key: K.Type) -> K.Value where K: SwiftPressoInjectionKey {
        get {
            key.currentValue
        }
        set {
            key.currentValue = newValue
        }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<SwiftPressoInjectedValues, T>) -> T {
        get {
            current[keyPath: keyPath]
        }
        set {
            current[keyPath: keyPath] = newValue
        }
    }
    
}
