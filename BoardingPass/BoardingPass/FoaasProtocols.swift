//
//  FoaasProtocols.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

/*
 The spec lists the JSONConvertible protocol as:
 
 protocol JSONConvertible {
    init?(json: [String : AnyObject])
    func toJson() -> [String : AnyObject]
 }

 please correct this
 */
protocol JSONConvertible {
    init?(json: [String : Any])
    func toJson() -> [String : Any]
}

protocol DataConvertible {
    init?(data: Data)
    func toData() throws -> Data
}
