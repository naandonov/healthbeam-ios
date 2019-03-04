//
//  GetPendingAlertsOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class GetPendingAlertsOperation: BaseSignedOperation<[PatientAlert]> {
    
    private override init() {
        super.init()
    }
    
    convenience init(completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.pendingAlerts.endpointString,
                               params: nil,
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
}
