//
//  Foaas.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

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
        guard let message = json["message"] as? String,
            let subtitle = json["subtitle"] as? String else { return nil }
        self.message = message
        self.subtitle = subtitle
    }
    
    func toJson() -> [String : AnyObject] {
        let fooasDict: [String : AnyObject] = [
            "message" : self.message as AnyObject,
            "subtitle" :self.subtitle as AnyObject
        ]
        return fooasDict
    }
    
}
