//
//  FoaasProtocols.swift
//  BoardingPass
//
//  Created by Cris on 11/23/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
protocol JSONConvertible {
    init?(json: [String : Any])
    func toJson() -> [String : Any]
}

protocol DataConvertible {
    init?(data: Data)
    func toData() throws -> Data
}
