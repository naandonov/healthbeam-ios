//
//  OperationProtocol.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public typealias Networkable = OperationProtocol & CompletionProtocol

public protocol OperationProtocol {
    
    var request: RequestProtocol? { get set }
    
    func execute<T>(in service: ServiceProtocol, completion: @escaping (Result<T>) -> Swift.Void) where T : Codable
}

extension OperationProtocol {
    public func execute<T>(in service: ServiceProtocol, completion: @escaping (Result<T>) -> Swift.Void) where T : Codable {
        guard let request = self.request else {
            completion(Result.failure(MSError.error))
            return
        }
        
        service.execute(request) { (result: Result<T>) in
            completion(result)
        }
    }
}

public typealias CompletionBlock<T> = ((Result<T>) -> Void)

public protocol CompletionProtocol {
    associatedtype ResponseType where ResponseType : Codable
    
    var completion: CompletionBlock<ResponseType>? { get set}
}
