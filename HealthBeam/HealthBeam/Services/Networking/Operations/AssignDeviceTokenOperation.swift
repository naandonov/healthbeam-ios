//
//  AssignDeviceTokenOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class AssignDeviceTokenOperation: BaseSignedOperation<GenericResponse> {
    
    private override init() {
        super.init()
    }
    
    convenience init(deviceToken: String, completion: CompletionBlock<ResponseType>?) {
        self.init()
        
        let body = ["deviceToken" : deviceToken]
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.userDeviceToken.endpointString,
                               params: nil,
                               fields: nil,
                               body: RequestBody.json(body))
        self.completion = completion
    }
    
}
