//
//  DeletePatientOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class DeletePatientOperation: BaseSignedOperation<GenericResponse> {
    
    private override init() {
        super.init()
    }
    
    convenience init(patientId: Int, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .delete,
                               endpoint: APIConstants.EndPoint.patientDelete.endpointString,
                               params: [APIConstants.EndPoint.patientIdSubstitutionKey: patientId],
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
}
