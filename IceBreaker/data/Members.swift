//
//  Members.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class Members: NSObject {

    static var instance: Members! = nil
    static func getInstance() -> Members {
        if instance == nil {
            instance = Members()
        }
        
        return instance
    }

    var members: [MemberInfo]
    var count: Int
    
    override init() {
        members = [MemberInfo]()
        for var i = 0; i < 20; i++ {
            members.append(MemberInfo())
        }
        count = 2
    }
    
    func findGroupLeaderIndex() -> Int? {
        if count == 0 {
            return nil
        }
        
        var values: [Int] = [Int]()
        for var i = 0; i < count; i++ {
            values.append(members[i].getValue())
        }

        let maxValue: Int = values.maxElement()!
        for var i = 0; i < count; i++ {
            if members[i].getValue() == maxValue {
                return i
            }
        }
        return nil
    }
}
