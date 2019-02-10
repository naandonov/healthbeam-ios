//
//  SubscriptionToggleOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class SubscriptionToggleOperation: BaseSignedOperation<PatientDetails.SubscriptionToggleResult> {
    
    private override init() {
        super.init()
    }
    
    convenience init(toggleRequest: PatientDetails.SubscriptionToggleRequest, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.toggleSubscription.endpointString,
                               params: nil,
                               fields: nil,
                               body: RequestBody.codable(toggleRequest))
        self.completion = completion
    }
    
}
