extension InjectedValues {
    public var categoryList: CategoryListProviderProtocol {
        get {
            Self[CategoryListProviderKey.self]
        }
        set {
            Self[CategoryListProviderKey.self] = newValue
        }
    }
}

private enum CategoryListProviderKey: InjectionKey {
    static var currentValue: CategoryListProviderProtocol = SPFactory.categoryListProvider()
}
