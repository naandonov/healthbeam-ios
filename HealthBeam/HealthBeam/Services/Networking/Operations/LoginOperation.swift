//
//  LoginOperation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class LoginOperation: BaseUnsignedOperation<Login.Result> {

    private override init() {
        super.init()
    }
    
    convenience init(request: Login.Interaction.Request, completion: CompletionBlock<ResponseType>?) {
        self.init()
        self.request = Request(method: .post,
                               endpoint: APIConstants.EndPoint.login.endpointString,
                               params: nil,
                               fields: nil,
                               body: RequestBody.codable(request))
        self.completion = completion
    }
}
