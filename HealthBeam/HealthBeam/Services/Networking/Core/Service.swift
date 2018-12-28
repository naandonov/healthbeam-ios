//
//  Service.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

enum MSError: Error {
    case error
    case unableToParseJSON
    case badRequest
    case generic(message: String)
    case responseValidation(errorCode: Int)
}

public final class Box<T> {
    let value: T?
    
    init(value: T?) {
        self.value = value
    }
}

public enum Result<T> {
    case success(Box<T>)
    case failure(Error)
}

public class Service: ServiceProtocol {
    public var configuration: ServiceConfig
    public var headers: HeadersDict
    
    public var session: URLSession
    
    public required init(_ configuration: ServiceConfig) {
        self.configuration = configuration
        headers = configuration.headers
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func execute<T>(_ request: RequestProtocol, completion: @escaping (Result<T>) -> Void) where T : Codable {
        guard let urlRequest = try? request.urlRequest(in: self) else {
            completion(Result.failure(MSError.badRequest))
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(Result.failure(MSError.generic(message: (error?.localizedDescription) ?? "Unknown Error")))
                }
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                self.validateResponse(response: httpURLResponse) else {
                    DispatchQueue.main.async {
                        completion(Result.failure(MSError.responseValidation(errorCode: ((response as? HTTPURLResponse)?.statusCode) ?? -1)))
                    }
                    return
            }
            
            DispatchQueue.main.async {
                let response = Response(response: httpURLResponse, data: data, request: request)
                
                guard let object: ResponseData<T> = response.decode() else {
                    completion(Result.failure(MSError.unableToParseJSON))
                    return
                }
                
                completion(Result.success(Box(value: object.result)))
            }
        }

        dataTask.resume()
    }
}

private extension Service {
    func validateResponse(response: HTTPURLResponse?) -> Bool {
        guard let response = response else { return false }
        
        if response.statusCode == 200 {
            return true
        }
        
        return false
    }
}


