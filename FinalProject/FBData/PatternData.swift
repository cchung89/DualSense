//
//  PatternData.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/22/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PatternData: NSObject {
    
    var name: String
    var success: Int
    var total: Int
    let ref : DatabaseReference?
    
    init(name: String) {
        self.name = name
        self.success = 0
        self.total = 0
        ref = nil
        
        super.init()
    }
    
    init(name: String, success: Int, total: Int) {
        self.name = name
        self.success = success
        self.total = total
        ref = nil
        
        super.init()
    }
    
    init(key: String, snapshot: DataSnapshot) {
        name = key
        let snaptemp = snapshot.value as! [String : AnyObject]
        let snapvalues = snaptemp[key] as! [String : AnyObject]
        print("snapvalues: \(snapvalues)")
        success = snapvalues["success"] as! Int
        total = snapvalues["total"] as! Int
        ref = snapshot.ref
    }
    
    func printResult() {
        print("success: \(success)")
        print("total: \(total)")
        print()
    }
    
    func toAnyObject() -> Any {
        
        return [
            "name": name,
            "success": success,
            "total": total
        ]
    }
}
