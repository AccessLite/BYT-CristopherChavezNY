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

// Again, nice that you added this, but not in spec
enum OperationErrorHandler: Error {
    case name, url, fields
}
struct  FoaasOperation: JSONConvertible, DataConvertible {
    let name: String
    let urlString: String
    let fields: [FoaasField]
    
    init?(json: [String : Any]) {
        do {
            guard let name = json["name"] as? String else { throw OperationErrorHandler.name}
            guard let urlString = json["url"] as? String else { throw OperationErrorHandler.url }
            guard let fieldsArr = json["fields"] as? [[String : Any]] else { throw OperationErrorHandler.fields }
            var fieldsInfo = [FoaasField]()
            for fields in fieldsArr {
                guard let fieldsInfo1 = FoaasField(json: fields) else { return nil }
                fieldsInfo.append(fieldsInfo1)
            }
            self.name = name
            self.urlString = urlString
            self.fields = fieldsInfo
        }
        catch OperationErrorHandler.name {
            print("ERROR PARSING NAME")
        }
        catch OperationErrorHandler.url {
            print("ERROR PARSING URL")
        }
        catch  {
            print("UNKWON Error: \(error)")
        }
        return nil
    }
    
    // should be toJson() -> [String : AnyObject]
    func toJson() -> [String : Any] {
        let dict: [String : Any] = [
            "name" : self.name,
            "urlString" : self.urlString,
            "fields" : self.fields
        ]
        return dict
    }
    
    
    init?(data: Data) {
        do {
            let backToJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let validDict = backToJSON {
                let _ = FoaasOperation(json: validDict)
            } else {
                return nil
            }
        }
        catch {
            print("ERROR CASTING DATA \(error)")
        }
        return nil
    }
    
    // re-think how you wrote this function. Is your function ever actually going to throw?
    // Also, should toData() handle a throw or should the caller? 
    // In answering those questions you should be able to write this in a single line
    func toData() throws -> Data {
        let operationDict = toJson()
        var dataToReturn = Data()
        do {
            let operationData = try JSONSerialization.data(withJSONObject: operationDict, options: [])
            dataToReturn = operationData
        }
        catch {
            print("ERROR CREATING THE OPERATIONDATA: \(error)")
        }
        return dataToReturn
    }
}
