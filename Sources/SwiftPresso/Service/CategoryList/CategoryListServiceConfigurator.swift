import SkavokNetworking

public struct CategoryListServiceConfigurator {
    
    private enum Constants {
        enum Keys {
            static let embedParameter = "_embed"
            static let pageParameter = "page"
            static let perPageParameter = "per_page"
        }
        
        enum Values {
            static let perPage = "50"
        }
    }
}

// MARK: - CategoriesServiceConfigurator

extension CategoryListServiceConfigurator: CategoryListConfiguratorProtocol {
   public func categoriesRequest() -> Request<[Category]> {
        let path = Endpoint.path(for: .categories)
        
        return Request(path: path)
    }
}
