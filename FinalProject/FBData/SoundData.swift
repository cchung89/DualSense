//
//  SoundData.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/5/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SoundData: NSObject {
    
    struct SuccessRate {
        var success: Int
        var total: Int
        
        init(success: Int, total: Int) {
            self.success = success
            self.total = total
        }
    }
    
    var name: String
    var _250: SuccessRate
    var _500: SuccessRate
    var _1000: SuccessRate
    var _2000: SuccessRate
    var _4000: SuccessRate
    var _8000: SuccessRate
    let ref: DatabaseReference?
    
    init(name: String) {
        self.name = name
        self._250 = SuccessRate(success: 0, total: 0)
        self._500 = SuccessRate(success: 0, total: 0)
        self._1000 = SuccessRate(success: 0, total: 0)
        self._2000 = SuccessRate(success: 0, total: 0)
        self._4000 = SuccessRate(success: 0, total: 0)
        self._8000 = SuccessRate(success: 0, total: 0)
        ref = nil
        
        super.init()
    }
    
    init(name: String, _250: SuccessRate, _500: SuccessRate, _1000: SuccessRate, _2000: SuccessRate, _4000: SuccessRate, _8000: SuccessRate) {
        self.name = name
        self._250 = _250
        self._500 = _500
        self._1000 = _1000
        self._2000 = _2000
        self._4000 = _4000
        self._8000 = _8000
        ref = nil
        
        super.init()
    }
    
    init(key: String, snapshot: DataSnapshot) {
        name = key
        let snaptemp = snapshot.value as! [String : AnyObject]
        let snapvalues = snaptemp[key] as! [String : AnyObject]
        print("snapvalues: \(snapvalues)")
        _250 = SuccessRate(success: (snapvalues["250"]!["success"])! as! Int, total: (snapvalues["250"]!["total"])! as! Int)
        _500 = SuccessRate(success: (snapvalues["500"]!["success"])! as! Int, total: (snapvalues["500"]!["total"])! as! Int)
        _1000 = SuccessRate(success: (snapvalues["1000"]!["success"])! as! Int, total: (snapvalues["1000"]!["total"])! as! Int)
        _2000 = SuccessRate(success: (snapvalues["2000"]!["success"])! as! Int, total: (snapvalues["2000"]!["total"])! as! Int)
        _4000 = SuccessRate(success: (snapvalues["4000"]!["success"])! as! Int, total: (snapvalues["4000"]!["total"])! as! Int)
        _8000 = SuccessRate(success: (snapvalues["8000"]!["success"])! as! Int, total: (snapvalues["8000"]!["total"])! as! Int)
        ref = snapshot.ref
    }
    
    func printResult() {
        print("\(_250.success) / \(_250.total)")
        print("\(_500.success) / \(_500.total)")
        print("\(_1000.success) / \(_1000.total)")
        print("\(_2000.success) / \(_2000.total)")
        print("\(_4000.success) / \(_4000.total)")
        print("\(_8000.success) / \(_8000.total)")
        print()
    }
    
    func toAnyObject() -> Any {
        
        return [
            "name": name,
            "250": ["success": _250.success, "total": _250.total],
            "500": ["success": _500.success, "total": _500.total],
            "1000": ["success": _1000.success, "total": _1000.total],
            "2000": ["success": _2000.success, "total": _2000.total],
            "4000": ["success": _4000.success, "total": _4000.total],
            "8000": ["success": _8000.success, "total": _8000.total]
        ]
    }
}
