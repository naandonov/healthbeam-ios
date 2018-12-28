//
//  ServiceConfig.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public final class ServiceConfig {
    private(set) var name: String
    
    private(set) var url: URL
    
    private(set) var headers: HeadersDict = ["Content-Type":"application/json"]
    
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    public var timeout: TimeInterval = 15.0
    
    public init?(name: String? = nil, base urlString: String, isAuthorizationRequired: Bool
         = false) {
        guard let url = URL(string: urlString) else { return nil}
        
        self.url = url
        self.name = name ?? (url.host ?? "")
        
        if isAuthorizationRequired, let token = AuthorizationWorker().getAuthorizationToken() {
            self.headers["Authorization"] = "Bearer \(token)"
        }
    }
}
