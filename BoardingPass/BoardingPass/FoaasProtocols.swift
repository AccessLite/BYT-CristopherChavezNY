//
//  FoaasProtocols.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

protocol JSONConvertible {
    init?(json: [String : AnyObject])
    func toJson() -> [String : AnyObject]
}

protocol DataConvertible {
    init?(data: Data)
    func toData() throws -> Data
}

