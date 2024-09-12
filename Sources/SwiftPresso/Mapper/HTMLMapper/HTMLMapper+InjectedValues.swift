extension SwiftPressoInjectedValues {
    public var htmlMapper: HTMLMapperProtocol {
        get {
            Self[PageProviderKey.self]
        }
        set {
            Self[PageProviderKey.self] = newValue
        }
    }
}

private enum PageProviderKey: SwiftPressoInjectionKey {
    static var currentValue: HTMLMapperProtocol = SwiftPresso.Mapper.htmlMapper()
}

