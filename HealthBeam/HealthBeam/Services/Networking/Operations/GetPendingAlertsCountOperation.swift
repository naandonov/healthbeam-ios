//
//  GetPendingAlertsCountOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 4.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class GetPendingAlertsCountOperation: BaseSignedOperation<PatientAlerts.Details> {
    
    private override init() {
        super.init()
    }
    
    convenience init(completion: CompletionBlock<ResponseType>?) {
        self.init() 
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.pendingAlertsCount.endpointString,
                               params: nil,
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
}
