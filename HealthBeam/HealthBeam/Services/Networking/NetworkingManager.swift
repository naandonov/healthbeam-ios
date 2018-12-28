//
//  NetworkingManager.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private let operationQueue: OperationQueue
    
    init() {
        self.operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func addNetwork(operation: BaseOperation) {
        self.operationQueue.addOperation(operation)
    }
}
