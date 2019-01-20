//
//  BaseSignedOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class BaseSignedOperation<T: Codable>: BaseOperation, Networkable {
    typealias ResponseType = T
    var request: RequestProtocol?
    var completion: CompletionBlock<ResponseType>?
    
    override func main() {
        guard let serviceConfig = ServiceConfig(base: APIConstants.BaseURL.healthBeamRoot.urlString) else {
            state = .finished
            return
        }
        let service = Service(serviceConfig)
        
        guard let authorizationWorker = Injector.authorizationWorker else {
            log.error("Missing AuthorizationWorker implementaion")
            state = .finished
            return
        }
        if let token = authorizationWorker.getAuthorizationToken() {
            service.headers["Authorization"] = "Bearer \(token)"
        }
        
        state = .executing
        execute(in: service) { [weak self] (result: Result<ResponseType>) in
            guard let strongSelf = self else {
                return
            }
            
            if case let .failure(responseObject) = result {
                if case let .responseValidation(errorCode) = responseObject, errorCode == 401 {
                    do {
                        try authorizationWorker.revokeAuthorization()
                    } catch {
                        log.error("Unable to revoke current authorization, reason: \(error.localizedDescription)")
                    }
                }
            }
            
            strongSelf.completion?(result)
            strongSelf.state = .finished
        }
    }
}
