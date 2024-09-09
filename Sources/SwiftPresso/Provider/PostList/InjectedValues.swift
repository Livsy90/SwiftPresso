extension InjectedValues {
    public var postList: PostListProviderProtocol {
        get {
            Self[PostListProviderKey.self]
        }
        set {
            Self[PostListProviderKey.self] = newValue
        }
    }
}

private enum PostListProviderKey: InjectionKey {
    static var currentValue: PostListProviderProtocol = SPFactory.postListProvider()
}
