//
//  AssignPatientTagOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class AssignPatientTagOperation: BaseSignedOperation<PatientTag> {
    
    private override init() {
        super.init()
    }
    
    convenience init(patientId: Int, beacon: Beacon, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.assignPatientTag.endpointString,
                               params: [APIConstants.EndPoint.patientIdSubstitutionKey: patientId],
                               fields: nil,
                               body: RequestBody.codable(beacon))
        self.completion = completion
    }
}
