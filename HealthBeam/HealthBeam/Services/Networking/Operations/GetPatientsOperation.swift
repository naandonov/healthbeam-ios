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
    
    convenience init(searchQuery: String?=nil, pageQuery: Int?=nil, completion: CompletionBlock<ResponseType>?) {
        self.init()
        var fields: ParametersDict = [:]
        if let searchQuery = searchQuery {
            fields["search"] = searchQuery
        }
        if let pageQuery = pageQuery {
            fields["page"] = pageQuery
        }
        
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.patients.endpointString,
                               params: nil,
                               fields: fields,
                               body: nil)
        self.completion = completion
    }
    
}
