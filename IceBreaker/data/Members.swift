//
//  Members.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics

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
        for var i = 0; i < count - 1; i++ {
            values.append(members[i].getValue())
        }

        let maxValue: Int = values.maxElement()!
        for var i = 0; i < count - 1; i++ {
            if members[i].getValue() == maxValue {
                return i
            }
        }
        return nil
    }
    
    func findMean() -> Int {
        var values: [Double] = [Double]()
        for var i = 0; i < count; i++ {
            values.append(Double(members[i].getValue()))
        }
        
        let aver = Sigma.average(values)
        return Int(aver!)
    }

    func findMedian() -> Int {
        var values: [Double] = [Double]()
        for var i = 0; i < count; i++ {
            values.append(Double(members[i].getValue()))
        }
        
        let median = Sigma.median(values)
        return Int(median!)
    }

    func findRange() -> Int {
        var values: [Double] = [Double]()
        for var i = 0; i < count; i++ {
            values.append(Double(members[i].getValue()))
        }
        
        let min = Sigma.min(values)
        let max = Sigma.max(values)
        return Int(max! - min!)
    }
    
}
