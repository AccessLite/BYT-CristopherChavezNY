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
        let data: [Data] = operations.flatMap{ try? $0.toData() }
        FoaasDataManager.defaults.set(data, forKey: FoaasDataManager.operationsKey)
        self.operations = operations
    }
    
    func getFoaas(url: URL, completion: @escaping (Foaas) -> Void) {
        FoaasAPIManager.getFoaas(url: url) { (foass: Foaas) in
            completion(foass)
        }
    }

    
    func load() -> Bool {
        guard let opsData = FoaasDataManager.defaults.value(forKey: FoaasDataManager.operationsKey) as? [Data] else { return false }
        var arr = [FoaasOperation]()
        for dta in opsData {
            guard let this = FoaasOperation(data: dta) else { return false }
            arr.append(this)
        }
        self.operations = arr
        return true
    }
    
    func deletedSortedOperations() {
        FoaasDataManager.defaults.removeObject(forKey: FoaasDataManager.operationsKey)
        self.operations = nil
    }
    
}
