//
//  UpdateHealthRecordOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class UpdateHealthRecordOperation: BaseSignedOperation<HealthRecord> {
    
    private override init() {
        super.init()
    }
    
    convenience init(healthRecord: HealthRecord, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .put,
                               endpoint: APIConstants.EndPoint.healthRecordModification.endpointString,
                               params: nil,
                               fields: nil,
                               body: RequestBody.codable(healthRecord))
        self.completion = completion
    }
}
