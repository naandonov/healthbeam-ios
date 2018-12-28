//
//  ServiceProtocol.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

public protocol ServiceProtocol {
    var configuration: ServiceConfig { get }
    
    var headers: HeadersDict { get }
    
    init(_ configuration: ServiceConfig)
    
    func execute<T>(_ request: RequestProtocol, completion: @escaping (Result<T>) -> Swift.Void) where T : Codable
}
