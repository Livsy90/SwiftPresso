//
//  PostListServiceConfigurator.swift
//  
//
//  Created by Livsy on 05.04.2024.
//

import SkavokNetworking

public struct PageListServiceConfigurator: PageListConfiguratorProtocol {

    public func pagesRequest() -> Request<[WPPost]> {
        let path = Endpoint.path(for: .pages)
        
        return Request(path: path)
    }
    
}
