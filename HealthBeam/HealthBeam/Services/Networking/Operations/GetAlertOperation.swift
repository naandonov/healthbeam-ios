//
//  GetAlertOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class GetAlertOperation: BaseSignedOperation<PatientAlert> {
    
    private override init() {
        super.init()
    }
    
    convenience init(alertId: String, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.alert.endpointString,
                               params: [APIConstants.EndPoint.alertIdSubstitutionKey: alertId],
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
    
    
}
