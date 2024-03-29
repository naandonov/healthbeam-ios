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
    
    convenience init(patientsSegment: PatientsSearch.Segment, searchQuery: String?=nil, pageQuery: Int?=nil, completion: CompletionBlock<ResponseType>?) {
        self.init()
        var fields: ParametersDict = [:]
        if let searchQuery = searchQuery {
            fields["search"] = searchQuery
        }
        if let pageQuery = pageQuery {
            fields["page"] = pageQuery
        }
        
        let endpoint: String
        switch patientsSegment {
        case .all:
            endpoint = APIConstants.EndPoint.patients.endpointString
        case .observed:
            endpoint = APIConstants.EndPoint.subscriptions.endpointString
        }
        
        self.request = Request(method: .get,
                               endpoint: endpoint,
                               params: nil,
                               fields: fields,
                               body: nil)
        self.completion = completion
    }
    
}
