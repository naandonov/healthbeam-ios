//
//  GetPatientAttributesOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class GetPatientAttributesOperation: BaseSignedOperation<PatientAttributes> {
    
    private override init() {
        super.init()
    }
    
    convenience init(patientId: Int, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.patientAttributes.endpointString,
                               params: [APIConstants.EndPoint.patientIdSubstitutionKey: patientId],
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
    
}
