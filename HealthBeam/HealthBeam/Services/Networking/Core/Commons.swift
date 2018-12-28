//
//  Commons.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public typealias ParametersDict = [String : Any?]

public typealias HeadersDict = [String: String]

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkError: Error {
    case dataIsNotEncodable(_: Any)
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case error(_: ResponseProtocol)
    case noResponse(_: ResponseProtocol)
    case missingEndpoint
}

public struct RequestBody {
    
    let data: Any
    let encoding: Encoding
    
    public enum Encoding {
        case rawData
        case rawString(_: String.Encoding?)
        case json
        case urlEncoded(_: String.Encoding?)
        case custom(_: CustomEncoder)
        
        public typealias CustomEncoder = ((Any) -> (Data))
    }
    
    ///Init
    private init(_ data: Any, as encoding: Encoding = .json) {
        self.data = data
        self.encoding = encoding
    }
    
    /// Codable
    public static func codable<T: Codable>(_ data: T) -> RequestBody {
        return try! RequestBody(JSONEncoder().encode(data), as: .rawData)
    }
    
    /// jSON
    public static func json(_ data: Any) -> RequestBody {
        return RequestBody(data, as: .json)
    }
    
    /// Raw Data
    public static func raw(data: Data) -> RequestBody {
        return RequestBody(data, as: .rawData)
    }
    
    /// Raw String
    public static func raw(string: String, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(string, as: .rawString(encoding))
    }
    
    ///URL Encoded
    public static func urlEncoded(_ data: ParametersDict, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(data, as: .urlEncoded(encoding))
    }
    
    public static func custom(_ data: Data, encoder: @escaping Encoding.CustomEncoder) -> RequestBody {
        return RequestBody(data, as: .custom(encoder))
    }
    
    public func encodedData() throws -> Data {
        switch encoding {
        case .rawData:
            return data as! Data
        case .rawString(let encoding):
            
            guard let string = (data as! String).data(using: encoding ?? .utf8) else {
                throw NetworkError.dataIsNotEncodable(data)
            }
            return string
        case .json:
            
            return try JSONSerialization.data(withJSONObject: data, options: [])
        case .urlEncoded(let encoding):
            
            let encodedString = try (data as! ParametersDict).urlEncodedString()
            guard let data = encodedString.data(using: encoding ?? .utf8) else {
                throw NetworkError.dataIsNotEncodable(encodedString)
            }
            return data
        case .custom(let encodingFunc):
            
            return encodingFunc(self.data)
        }
    }
    
    public func encodedString(_ encoding: String.Encoding = .utf8) throws -> String {
        let encodedData = try self.encodedData()
        guard let stringRepresentation = String(data: encodedData, encoding: encoding) else {
            throw NetworkError.stringFailedToDecode(encodedData, encoding: encoding)
        }
        return stringRepresentation
    }
}

public struct ResponseData<T>: Codable where T : Codable {
//    let status: Int
    let result: T?
}

