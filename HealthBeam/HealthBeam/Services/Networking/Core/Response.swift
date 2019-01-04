//
//  Response.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public class Response: ResponseProtocol {
    public let type: ResponseResult
    
    public var httpStatusCode: Int? {
        return type.code
    }
    
    public let httpResponse: HTTPURLResponse?
    public var data: Data?
    public let request: RequestProtocol
    
    public init(response: HTTPURLResponse, data: Data?, request: RequestProtocol) {
        self.type = ResponseResult.from(response: response)
        self.httpResponse = response
        self.data = data
        self.request = request
    }
    
    public func decode<T>() -> T? where T : Codable {
        guard let data = data else { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error {
            log.error(error)
            return nil
        }
    }
    
    public func toJSON() -> Any? {
        guard let data = data else { return nil }
        
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
    
    public func toString(_ encoding: String.Encoding?) -> String? {
        guard let data = self.data else { return nil }
        
        return String(data: data, encoding: encoding ?? .utf8)
    }
}
