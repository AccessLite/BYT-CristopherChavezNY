//
//  FoaasDataManager.swift
//  BoardingPass
//
//  Created by Cris on 11/24/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation


// You dont these save/load methods implemented anywhere.
// Also, your save/load operations are going to fail as they are currently written
class FoaasDataManager {
    static let shared: FoaasDataManager = FoaasDataManager()
    init() {}
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    // TODO: Use your protocol functions to properly do data conversions
    func save(operations: [FoaasOperation]) {
        if var operationsFoaasDefaults = FoaasDataManager.defaults.object(forKey: FoaasDataManager.operationsKey) as? [[FoaasOperation]] {
            operationsFoaasDefaults.append(operations)
            FoaasDataManager.defaults.set(operationsFoaasDefaults, forKey: FoaasDataManager.operationsKey)
        } else {
            FoaasDataManager.defaults.set([operations], forKey: FoaasDataManager.operationsKey)
        }
    }
    
    // TODO: Fix these warnings
    // TODO: Use your protocols to properly do data conversions
    func load() -> Bool {
        
        var success = false
        if let operationsFoaasDefaults = FoaasDataManager.defaults.object(forKey: FoaasDataManager.operationsKey) as? [[FoaasOperation]] {
            operationsFoaasDefaults.forEach({ (FoaasDefault) in
                guard let FoaasDefault1 = FoaasDefault as? [String : AnyObject] else {return}
                FoaasOperation(json: FoaasDefault1)
                
            })
        }
        
        return success
    }
    
    func deletedSortedOperations() {
        FoaasDataManager.defaults.removeObject(forKey: FoaasDataManager.operationsKey)
        self.operations = nil 
    }
}
