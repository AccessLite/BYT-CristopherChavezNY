//
//  FoaasField.swift
//  BoardingPass
//
//  Created by Cris on 11/24/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

struct FoaasField: JSONConvertible, CustomStringConvertible {
    let fieldsName: String
    let fieldsField: String
    var description: String {
        return "\(fieldsName) \(fieldsField)"
    }
    
    init?(json: [String : AnyObject]) {
        guard let fieldsName = json["name"] as? String,
            let fieldsField = json["field"] as? String else { return nil }
            self.fieldsName = fieldsName
            self.fieldsField = fieldsField
    }
    
    func toJson() -> [String : AnyObject] {
        let dictToReturn: [ String : AnyObject] = [
            "fieldsName" : self.fieldsName as AnyObject,
            "fieldsField" : self.fieldsField as AnyObject
        ]
        return dictToReturn
    }
}
