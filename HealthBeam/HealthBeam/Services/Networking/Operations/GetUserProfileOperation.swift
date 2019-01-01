//
//  GetUserProfileOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class GetUserProfileOperation: BaseSignedOperation<UserProfile.Model> {
    
    private override init() {
        super.init()
    }
    
    convenience init(completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .get,
                               endpoint: APIConstants.EndPoint.user.endpointString,
                               params: nil,
                               fields: nil,
                               body: nil)
        self.completion = completion
    }
}
