//
//  GetPatientsOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 4.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class GetPatientsOperation: BaseSignedOperation<BatchResult<Patient>> {
    
    private override init() {
        super.init()
    }
    
    convenience init(searchQuery: String?=nil, completion: CompletionBlock<ResponseType>?) {
        self.init()
        var parmaeters: ParametersDict = [:]
        if let searchQuery = searchQuery {
            parmaeters["search"] = searchQuery
        }
        
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.patients.endpointString,
                               params: parmaeters,
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
    
}
