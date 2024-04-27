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
            static let embedParameter = "_embed"
            static let pageParameter = "page"
            static let perPageParameter = "per_page"
        }
        
        enum Values {
            static let perPage = "50"
        }
    }
}

// MARK: - FeedServiceConfigurator

extension PostListServiceConfigurator: PostListConfiguratorProtocol {

    public func feedRequest(pageNumber: Int) -> Request<[WPPost]> {
        let parameters: [(String, String)] = [
            (Constants.Keys.embedParameter, ""),
            (Constants.Keys.pageParameter, "\(pageNumber)"),
            (Constants.Keys.perPageParameter, Constants.Values.perPage),
        ]
        let path = Endpoint.path(for: .posts)
        
        return Request(path: path, query: parameters)
    }
    
}
