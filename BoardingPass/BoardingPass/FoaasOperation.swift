//
//  FoaasOperation.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
/*
 Endpoint: /operations
 GET http://www.foaas.com/operations
 [
 {
 "name": "Awesome",
 "url": "/awesome/:from",
 "fields": [
 {
 "name": "From",
 "field": "from"
 }
 ]
 },
 { ... another operation ... },
 { ... another operation ... }
 ]
 */

struct  FoaasOperation: JSONConvertible, DataConvertible {
    let name: String
    let urlString: String
    let fields: [FoaasField]
    
    init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let urlString = json["url"] as? String,
            let fields = json["fields"] as? [[String : AnyObject]]    else { return nil}
        
        var fieldsInfo = [FoaasField]()
        
        fields.forEach { (field) in
            if let fieldToAppend = FoaasField(json: field) {
                fieldsInfo.append(fieldToAppend)
            }
        }
        self.name = name
        self.urlString = urlString
        self.fields = fieldsInfo
    }
    
    func toJson() -> [String : AnyObject] {
        let dict: [String : AnyObject] = [
            "name" : self.name as AnyObject,
            "urlString" : self.urlString as AnyObject,
            "fields" : self.fields.map{ $0.toJson() } as AnyObject
        ]
        return dict
    }
    
//    -- DataConvertible --
    
    init?(data: Data) {
        do {
            let validJSON = try JSONSerialization.jsonObject(with: data, options: [])
            guard let validObject = validJSON as? [String: AnyObject] else { return nil }
            self.init(json: validObject)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: toJson(), options: [])
    }
}
