//
//  Foaas.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

// This is a good instinct to add this ahead of time. 
// But be aware that this wasn't part of the spec, and costs extra development time
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
    
    init?(json: [String : Any]) {
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
    
    func toJson() -> [String : Any] {
        let fooasDict: [String : Any] = [
            "message" : self.message,
            "subtitle" :self.subtitle,
            
            // description isn't needed to be returned with the json
            //   toJson() is meant to prepare an object to be saved in UserDefaults for later loading
            //   "description" a computed value, so it serves no purpose by being stored 
            "description" : self.description
        ]
        return fooasDict
    }
}
