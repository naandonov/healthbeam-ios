//
//  RespondToAlertOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class RespondToAlertOperation: BaseSignedOperation<GenericResponse> {
    
    private override init() {
        super.init()
    }
    
    convenience init(respondRequest: AlertRespondNavigation.ProcessingRequest, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.respondToAlert.endpointString,
                               params: nil,
                               fields: nil,
                               body: RequestBody.codable(respondRequest))
        self.completion = completion
    }
    
}
