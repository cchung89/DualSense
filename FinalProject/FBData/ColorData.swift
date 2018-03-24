//
//  ColorData.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/7/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ColorData: NSObject {
    
    struct SuccessRate {
        var success: Int
        var total: Int
        
        init(success: Int, total: Int) {
            self.success = success
            self.total = total
        }
    }
    
    var name: String
    var red: SuccessRate
    var yellow: SuccessRate
    var blue: SuccessRate
    var orange: SuccessRate
    var green: SuccessRate
    var purple: SuccessRate
    let ref: DatabaseReference?
    
    init(name: String) {
        self.name = name
        self.red = SuccessRate(success: 0, total: 0)
        self.yellow = SuccessRate(success: 0, total: 0)
        self.blue = SuccessRate(success: 0, total: 0)
        self.orange = SuccessRate(success: 0, total: 0)
        self.green = SuccessRate(success: 0, total: 0)
        self.purple = SuccessRate(success: 0, total: 0)
        ref = nil
        
        super.init()
    }
    
    init(name: String, red: SuccessRate, yellow: SuccessRate, blue: SuccessRate, orange: SuccessRate, green: SuccessRate, purple: SuccessRate) {
        self.name = name
        self.red = red
        self.yellow = yellow
        self.blue = blue
        self.orange = orange
        self.green = green
        self.purple = purple
        ref = nil
        
        super.init()
    }
    
    init(key: String, snapshot: DataSnapshot) {
        name = key
        let snaptemp = snapshot.value as! [String : AnyObject]
        let snapvalues = snaptemp[key] as! [String : AnyObject]
        print("snapvalues: \(snapvalues)")
        red = SuccessRate(success: (snapvalues["red"]!["success"])! as! Int, total: (snapvalues["red"]!["total"])! as! Int)
        yellow = SuccessRate(success: (snapvalues["yellow"]!["success"])! as! Int, total: (snapvalues["yellow"]!["total"])! as! Int)
        blue = SuccessRate(success: (snapvalues["blue"]!["success"])! as! Int, total: (snapvalues["blue"]!["total"])! as! Int)
        orange = SuccessRate(success: (snapvalues["orange"]!["success"])! as! Int, total: (snapvalues["orange"]!["total"])! as! Int)
        green = SuccessRate(success: (snapvalues["green"]!["success"])! as! Int, total: (snapvalues["green"]!["total"])! as! Int)
        purple = SuccessRate(success: (snapvalues["purple"]!["success"])! as! Int, total: (snapvalues["purple"]!["total"])! as! Int)
        ref = snapshot.ref
    }
    
    func printResult() {
        print("red: \(red.success) / \(red.total)")
        print("yellow: \(yellow.success) / \(yellow.total)")
        print("blue: \(blue.success) / \(blue.total)")
        print("orange: \(orange.success) / \(orange.total)")
        print("green: \(green.success) / \(green.total)")
        print("purple: \(purple.success) / \(purple.total)")
        print()
    }
    
    func toAnyObject() -> Any {
        
        return [
            "name": name,
            "red": ["success": red.success, "total": red.total],
            "yellow": ["success": yellow.success, "total": yellow.total],
            "blue": ["success": blue.success, "total": blue.total],
            "orange": ["success": orange.success, "total": orange.total],
            "green": ["success": green.success, "total": green.total],
            "purple": ["success": purple.success, "total": purple.total]
        ]
    }
}

