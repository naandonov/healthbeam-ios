//
//  BaseUnsignedOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class BaseUnsignedOperation<T: Codable>: BaseOperation, Networkable {
    var completion: ((Result<T>) -> Void)?
    var request: RequestProtocol?
    typealias ResponseType = T
    
    override func main() {
        guard let serviceConfig = ServiceConfig(base: APIConstants.BaseURL.HealthBeamRoot.urlString) else {
            state = .finished
            return
        }
        
        let service = Service(serviceConfig)
        
        state = .executing
        execute(in: service) { [weak self] (result: Result<ResponseType>) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.completion?(result)
            log.debug(result)
            strongSelf.state = .finished
        }
    }
    
}
