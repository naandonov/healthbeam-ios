//
//  BaseOperation.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

class BaseOperation: Operation  {    
    enum State {
        case ready
        case executing
        case finished
        
        var keyPath: String {
            switch self {
            case .ready:
                return "isReady"
            case .executing:
                return "isExecuting"
            case .finished:
                return "isFinished"
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
}

