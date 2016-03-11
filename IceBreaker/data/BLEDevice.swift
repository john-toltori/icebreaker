//
//  BLEDevice.swift
//  IceBreaker
//
//  Created by toltori on 3/9/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class BLEDevice: NSObject {
    var name = ""
    var uuid = ""
    
    class func getUUIDString(uuid: CBUUID) -> String {
        return uuid.UUIDString
        /*
        let uuid_str = "\(uuid)"
        return uuid_str.substringFromIndex(uuid_str.endIndex.advancedBy(-36))
        */
    }
}
