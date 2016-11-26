//
//  FoaasDataManager.swift
//  BoardingPass
//
//  Created by Cris on 11/24/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

class FoaasDataManager {
    static let shared: FoaasDataManager = FoaasDataManager()
    init() {}
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?

    func save(operations: [FoaasOperation]) {
        
        
        //        let defaults = UserDefaults.standard
//        if var operationsFoaasDefaults = defaults.object(forKey: "operationsFoaas") as? [[FoaasOperation]] {
//            operationsFoaasDefaults.append(operations)
//            defaults.set(operationsFoaasDefaults, forKey: "operationsFoaas")
//        } else {
//            defaults.set([operations], forKey: "operationsFoaas")
//        }
    }
    
    func load() -> Bool {
        let success = false
        if let operationsFoaasDefaults = FoaasDataManager.defaults.object(forKey: "operationsFoaas") as? [[FoaasOperation]] {
            operationsFoaasDefaults.forEach({ (FoaasDefault) in
                let name = FoaasDefault.flatMap{$0.name}
                let urlString = FoaasDefault.flatMap{$0.urlString}
                
            })
        }
     return success
    }
    
    func deleteSortedOperations() {
    
    }
}
