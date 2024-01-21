public protocol WPPostPartsMapperProtocol {
    func map(htmlString: String) -> [WPPostParts]
}
