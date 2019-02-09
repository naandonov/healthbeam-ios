//
//  DeleteHealthRecordOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class DeleteHealthRecordOperation: BaseSignedOperation<GenericResponse> {
    
    convenience init(healthRecordId: Int, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .delete,
                               endpoint: APIConstants.EndPoint.healthRecordDelete.endpointString,
                               params: [APIConstants.EndPoint.patientIdSubstitutionKey: healthRecordId],
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
}
