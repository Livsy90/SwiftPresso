import SkavokNetworking

struct PostListServiceConfigurator {
    
    private enum Constants {        
        enum Keys {
            static let embed = "_embed"
            static let page = "page"
            static let perPage = "per_page"
            static let categories = "categories"
            static let tags = "tags"
            static let search = "search"
            static let include = "include"
        }
    }
    
}

// MARK: - FeedServiceConfigurator

extension PostListServiceConfigurator: PostListConfiguratorProtocol {

    func feedRequest(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?,
        includeIDs: [Int]?
    ) -> Request<[WPPost]> {
        
        var parameters: [(String, String)] = [
            (Constants.Keys.embed, ""),
            (Constants.Keys.page, "\(pageNumber)"),
            (Constants.Keys.perPage, "\(perPage)")
        ]
        
        if let searchTerms, !searchTerms.isEmpty {
            parameters.append((Constants.Keys.search, searchTerms))
        }
        
        if let categories, !categories.isEmpty {
            parameters.append((Constants.Keys.categories, categories.map { String($0) }.joined(separator: ",")))
        }
        
        if let tags, !tags.isEmpty {
            parameters.append((Constants.Keys.tags, tags.map { String($0) }.joined(separator: ",")))
        }
        
        if let includeIDs, !includeIDs.isEmpty {
            parameters.append((Constants.Keys.include, includeIDs.map { String($0) }.joined(separator: ",")))
        }
        
        let path = Endpoint.path(for: .posts)
        
        return Request(path: path, query: parameters)
    }
    
}
