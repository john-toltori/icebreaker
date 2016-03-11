//
//  BLEDataProcessor.swift
//  IceBreaker
//
//  Created by toltori on 3/9/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

protocol BLEDataProcessDelegate {
    func processData(data: UnsafeMutablePointer<UInt8>, length: Int32)
}

class BLEDataProcessor: NSObject {
    static var instance: BLEDataProcessor! = nil
    static func getInstance() -> BLEDataProcessor {
        if instance == nil {
            instance = BLEDataProcessor()
        }
        
        return instance
    }
    
    var processor: BLEDataProcessDelegate?
    override init() {
        processor = nil
    }
}