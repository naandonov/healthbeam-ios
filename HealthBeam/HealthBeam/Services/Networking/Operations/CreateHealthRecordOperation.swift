//
//  CreateHealthRecordOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class CreateHealthRecordOperation: BaseSignedOperation<HealthRecord> {
    
    private override init() {
        super.init()
    }
    
    convenience init(patientId: Int, healthRecord: HealthRecord, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.healthRecordCreate.endpointString,
                               params: [APIConstants.EndPoint.patientIdSubstitutionKey: patientId],
                               fields: nil,
                               body: RequestBody.codable(healthRecord))
        self.completion = completion
    }
    
}
