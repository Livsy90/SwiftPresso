protocol SwiftPressoInjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}
