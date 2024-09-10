extension SwiftPressoInjectedValues {
    public var categoryList: CategoryListProviderProtocol {
        get {
            Self[CategoryListProviderKey.self]
        }
        set {
            Self[CategoryListProviderKey.self] = newValue
        }
    }
}

private enum CategoryListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: CategoryListProviderProtocol = SwiftPresso.Provider.categoryListProvider()
}
