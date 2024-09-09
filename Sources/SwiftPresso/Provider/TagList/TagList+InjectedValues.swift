extension InjectedValues {
    public var tagList: TagListProviderProtocol {
        get {
            Self[TagListProviderKey.self]
        }
        set {
            Self[TagListProviderKey.self] = newValue
        }
    }
}

private enum TagListProviderKey: InjectionKey {
    static var currentValue: TagListProviderProtocol = SwiftPresso.Provider.tagListProvider
}
