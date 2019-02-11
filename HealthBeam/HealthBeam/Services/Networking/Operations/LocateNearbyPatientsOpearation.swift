//
//  LocateNearbyPatientsOpearation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 11.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class LocateNearbyPatientsOpearation: BaseSignedOperation<[Patient]> {

private override init() {
    super.init()
}

    convenience init(beacons: [Beacon], completion: CompletionBlock<ResponseType>?) {
    self.init()
    self.request = Request(method: .post,
                           endpoint: APIConstants.EndPoint.locateNearbyPatients.endpointString,
                           params: nil,
                           fields: nil,
                           body: RequestBody.codable(beacons))
    self.completion = completion
}

}
