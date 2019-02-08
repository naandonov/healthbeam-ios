//
//  CreatePatient.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class CreatePatientOperation: BaseSignedOperation<Patient> {
    
    private override init() {
        super.init()
    }
    
    convenience init(patient: Patient, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.patients.endpointString,
                               params: nil,
                               fields: nil,
                               body: RequestBody.codable(patient))
        self.completion = completion
    }
    
}
