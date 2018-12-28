//
//  ResponseProtocol.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public enum ResponseResult {
    case success(_: Int)
    case error(_: Int)
    case noResponse
    
    private static let successCodes: Range<Int> = 200..<299
    
    public static func from(response: HTTPURLResponse?) -> ResponseResult {
        guard let r = response else {
            return .noResponse
        }
        
        return (ResponseResult.successCodes.contains(r.statusCode) ? .success(r.statusCode) : .error(r.statusCode))
    }
    
    public var code: Int? {
        switch self {
        case .success(let code):
            return code
        case .error(let code):
            return code
        case .noResponse:
            return nil
        }
    }
}

public protocol ResponseProtocol {
    var type: ResponseResult { get }
    
    var request: RequestProtocol { get }
    
    var httpResponse: HTTPURLResponse? { get }
    
    var httpStatusCode: Int? { get }
    
    var data: Data? { get }
    
    func decode<T>() -> T? where T: Codable
    
    func toJSON() -> Any?
    
    func toString(_ encoding: String.Encoding?) -> String?
}
