//
//  SwiftPresso.swift
//
//
//  Created by Livsy on 05.04.2024.
//

import Foundation

public struct SwiftPressoFactory {
    
    public static func makePostListManager(
        url: URL,
        httpScheme: HTTPScheme,
        httpAdditionalHeaders: [AnyHashable: Any]?
    ) -> PostListManagerProtocol {
        
        let client = APIClientFactory.client(url: url, httpScheme: httpScheme, httpAdditionalHeaders: httpAdditionalHeaders)
        let configurator = PostListServiceConfigurator()
        let mapper = WPPostMapper()
        let service = PostListService(networkClient: client, configurator: configurator)
        
        return PostListManager(service: service, mapper: mapper)
    }
    
}
