//
//  PostListServiceConfigurator.swift
//  
//
//  Created by Livsy on 05.04.2024.
//

import SkavokNetworking

public struct PostListServiceConfigurator {
    
    private enum Constants {        
        enum Keys {
            static let embed = "_embed"
            static let page = "page"
            static let perPage = "per_page"
            static let categories = "categories"
            static let tags = "tags"
        }
    }
}

// MARK: - FeedServiceConfigurator

extension PostListServiceConfigurator: PostListConfiguratorProtocol {

    public func feedRequest(
        pageNumber: Int,
        perPage: Int,
        categories: [Int]?,
        tags: [Int]?
    ) -> Request<[WPPost]> {
        
        var parameters: [(String, String)] = [
            (Constants.Keys.embed, ""),
            (Constants.Keys.page, "\(pageNumber)"),
            (Constants.Keys.perPage, "\(perPage)")
        ]
        
        if let categories {
            parameters.append((Constants.Keys.categories, categories.map { String($0) }.joined(separator: ",")  ))
        }
        
        if let tags {
            parameters.append((Constants.Keys.tags, tags.map { String($0) }.joined(separator: ",")  ))
        }
        
        let path = Endpoint.path(for: .posts)
        
        return Request(path: path, query: parameters)
    }
    
}
