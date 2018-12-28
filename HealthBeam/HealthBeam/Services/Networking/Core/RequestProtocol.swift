//
//  RequestProtocol.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public protocol RequestProtocol {
    var invalidationToken: URLSessionDataTask? { get set }
    var context: URLSession? { get set }
    var endpoint: String { get set }
    var method: RequestMethod? { get set }
    var fields: ParametersDict? { get set }
    var urlParams: ParametersDict? { get set }
    var body: RequestBody? { get set }
    var headers: HeadersDict? { get set }
    var cachePolicy: URLRequest.CachePolicy? { get set }
    var timeout: TimeInterval? { get set }
    
    func headers(in service: ServiceProtocol) -> HeadersDict
    func url(in service: ServiceProtocol) throws -> URL
    func urlRequest(in service: ServiceProtocol) throws -> URLRequest
}

//MARK: - Provide default implementation of the Request
public extension RequestProtocol {
    func headers(in service: ServiceProtocol) -> HeadersDict {
        var params: HeadersDict = service.headers
        
        self.headers?.forEach({ k, v in params[k] = v})
        return params
    }
    
    func url(in service: ServiceProtocol) throws -> URL {
        let baseURL = service.configuration.url.absoluteString.appending(endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let fullURLString = try baseURL.fill(withValues: urlParams).stringByAdding(urlEncodedFields: fields)
        guard let url = URL(string: fullURLString) else {
            throw NetworkError.invalidURL(fullURLString)
        }
        
        return url
    }
    
    public func urlRequest(in service: ServiceProtocol) throws -> URLRequest {
        let requestURL = try url(in: service)
        
        let cachePolicy = self.cachePolicy ?? service.configuration.cachePolicy
        let timeout = self.timeout ?? service.configuration.timeout
        let headers = self.headers(in: service)
        
        // Create the URLRequest object
        var urlRequest = URLRequest(url: requestURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.httpMethod = (self.method ?? .get).rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        //TODO: - check if the "if" statement is required as URLReqeust httpBody takes an optional
        if let bodyData = try body?.encodedData() {
            urlRequest.httpBody = bodyData
        }
        return urlRequest
    }
}
