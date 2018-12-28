//
//  Request.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public class Request: RequestProtocol {
    public var context: URLSession?
    
    public var invalidationToken: URLSessionDataTask?
    public var endpoint: String
    public var body: RequestBody?
    public var method: RequestMethod?
    public var fields: ParametersDict?
    public var urlParams: ParametersDict?
    public var headers: HeadersDict?
    public var cachePolicy: URLRequest.CachePolicy?
    public var timeout: TimeInterval?
    
    public init(method: RequestMethod = .get, endpoint:String = "", params: ParametersDict? = nil, fields: ParametersDict? = nil, body: RequestBody? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.urlParams = params
        self.fields = fields
        self.body = body
    }
}
