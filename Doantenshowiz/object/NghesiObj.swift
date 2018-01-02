//
//  TinhObj.swift
//  IOS8SwiftTabBarControllerTutorial
//
//  Created by MacBook on 4/30/17.
//  Copyright © 2017 Arthur Knopper. All rights reserved.
//

import Foundation
import SwiftyJSON

class NghesiObj
{
    var name:String = ""
    var nameid:String = ""
    var urlimg:String = ""
    
    
    required init?(name: String?, nameid: String?, urlimg: String?) {
        self.name = name!
        self.nameid=nameid!
        self.urlimg=urlimg!
        
        
    }
    
    //    func description() -> String {
    //        return "ID: \(self.id)" +
    //            "User ID: \(self.userId)" +
    //            "Title: \(self.title)\n" +
    //        "Completed: \(self.completed)\n"
    //    }
    required init?(json: SwiftyJSON.JSON) {
        self.name = json["name"].string!
        self.nameid = json["nameid"].string!
        self.urlimg = json["urlimg"].string!
        
          }
    
    convenience init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let nameid = json["nameid"] as? String,
            let urlimg = json["urlimg"] as? String
                       else {
                return nil
        }
        
        self.init(name: name,nameid: nameid,urlimg: urlimg)    }
    
}
