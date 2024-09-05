//
//  SearchServiceConfigurator.swift
//  
//
//  Created by Livsy on 05.04.2024.
//

import SkavokNetworking

public struct SearchServiceConfigurator {
    
    private enum Constants {        
        enum Keys {
            static let embed = "_embed"
            static let page = "page"
            static let perPage = "per_page"
            static let search = "search"
        }
    }
}

// MARK: - FeedServiceConfigurator

extension SearchServiceConfigurator: SearchConfiguratorProtocol {

    public func feedRequest(
        pageNumber: Int,
        searchTerms: String,
        perPage: Int
    ) -> Request<[WPPost]> {
        
        let parameters: [(String, String)] = [
            (Constants.Keys.embed, ""),
            (Constants.Keys.page, "\(pageNumber)"),
            (Constants.Keys.perPage, String(perPage)),
            (Constants.Keys.search, searchTerms)
        ]
        let path = Endpoint.path(for: .posts)
        
        return Request(path: path, query: parameters)
    }
    
}
