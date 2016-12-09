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
            let fields = json["fields"] as? [[String : AnyObject]]
        else { return nil }
        
        self.name = name
        self.urlString = urlString
        self.fields = fields.flatMap { FoaasField(json: $0) }
    }
    
    func toJson() -> [String : AnyObject] {
        return [
            "name" : self.name as AnyObject,
            "urlString" : self.urlString as AnyObject,
            "fields" : self.fields.map { $0.toJson } as AnyObject // self.fields is of type [FoaasField], which if you try to save to UserDefaults it will crash
        ]
    }
    
    //    -- DataConvertible --
    
    init?(data: Data) {
        do {
            let backToJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
            guard let validJson = backToJSON,
                let validOperation = FoaasOperation(json: validJson) else {
                return nil
            }
            
            self = validOperation
            return
        }
        catch {
            print("ERROR CASTING DATA \(error)")
        }
        
        return nil
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
}
