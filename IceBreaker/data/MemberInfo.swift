//
//  MemberInfo.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class MemberInfo: NSObject {
    var name: String = ""
    var profileImage: UIImage! = nil
    var measures: [Int] = [Int]()
    var value: Int = 0
    
    func getValue() -> Int {
        if measures.count > 0 {
            var sum = 0
            for var i = 0; i < measures.count; i++ {
                sum += measures[i]
            }
            return sum / measures.count
        }
        return 0
    }
}
