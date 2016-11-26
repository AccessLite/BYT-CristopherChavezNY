//
//  Foaas.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum FoaasErrorHandler: Error {
    case jsonError, message, subtitle
}
/*
 // Enpoint: /awesome/:from
 // GET http://www.foaas.com/awesome/louis
 {
 "message": "This is Fucking Awesome.",
 "subtitle": "- louis"
 }
 */
struct Foaas: JSONConvertible, CustomStringConvertible {
    let message: String
    let subtitle: String
    var description : String {
        return "\(message) \(subtitle)"
    }
    
    init?(json: [String : AnyObject]) {
        do {
            guard let message = json["message"] as? String else {throw FoaasErrorHandler.message}
            guard let subtitle = json["subtitle"] as? String else {throw FoaasErrorHandler.subtitle}
            self.message = message
            self.subtitle = subtitle
        }
        catch FoaasErrorHandler.message {
            print("ERROR WITH PARSING MESSAGE")
        }
        catch FoaasErrorHandler.subtitle {
            print("ERROR WITH PARSING SUBTITLE")
        }
        catch {
            print("PRINT \(error)")
        }
        return nil
    }
    
    func toJson() -> [String : AnyObject] {
        let fooasDict: [String : AnyObject] = [
            "message" : self.message as AnyObject,
            "subtitle" :self.subtitle as AnyObject
        ]
        return fooasDict
    }
}
