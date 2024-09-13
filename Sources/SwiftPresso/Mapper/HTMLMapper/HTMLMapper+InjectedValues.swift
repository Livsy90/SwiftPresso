extension SwiftPressoInjectedValues {
    public var htmlMapper: any HTMLMapperProtocol {
        get {
            Self[PageProviderKey.self]
        }
        set {
            Self[PageProviderKey.self] = newValue
        }
    }
}

private enum PageProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any HTMLMapperProtocol = SwiftPresso.Mapper.htmlMapper()
}

