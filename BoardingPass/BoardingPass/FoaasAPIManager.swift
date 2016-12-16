//
//  FoaasAPIManager.swift
//  BoardingPass
//
//  Created by Cris on 11/24/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

enum ErrorManager: Error {
    case jsonError
}


class FoaasAPIManager {
    // TODO: Make Class Functions
    // Make sure you're reading the tech lead directions carefully: https://github.com/AccessLite/BoardingPass/blob/master/Week%201%20-%20MVP/Week1MVP_TechLeadInstructions.md#api-calls
    // I asked that this not be a singleton, but that all of the functions be class functions.
    // Please update this for week 2's submission
    
    //spaced will help readability. just group lines of code by their function to start
    internal func getFoaas(url: URL, completion: @escaping (Foaas) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("ENCOUNTERED ERROR: \(error)")
            }
            
            // you will never see two back-to-back if statements without a break in between
            if let responseFoaas = response as? HTTPURLResponse {
                print(responseFoaas.statusCode)
            }
            
            if let validData: Data = data {
                
                do {
                    let foaasJson = try JSONSerialization.jsonObject(with: validData, options: [])
                    guard let foaasDict = foaasJson as? [String : AnyObject] else {
                        throw ErrorManager.jsonError // Id prefer else statements that throw to be separated out to make it clear to another developer
                    }
                    
                    if let fooasReturn = Foaas(json: foaasDict) {
                        completion(fooasReturn)
                    }
                }
                catch ErrorManager.jsonError {
                    // here's a little something you might find helpful if you want to describe the function code is 
                    // executing in
                    print("ERROR WHEN CONVERTING DATA TO JSON. LOCATION: \(#function)")
                }
                catch {
                    print("THERE IS AN UNKNOWN \(error)")
                }
                
            }
            }.resume()
    }
    
    internal func getOperations(complete: @escaping ([FoaasOperation]?)-> Void) {
        
        guard let url: URL = URL(string: "http://www.foaas.com/operations") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("applications/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
           
            if error != nil {
                print("ERROR ENCOUNTERED: \(error)")
            }
            
            if let operationsResponse = response as? HTTPURLResponse {
                print(operationsResponse.statusCode)
            }
            
            if let validData: Data = data {
                
                var operationArr = [FoaasOperation]()
                do {
                    
                    let operationJson = try JSONSerialization.jsonObject(with: validData, options: [])
                    guard let operation = operationJson as? [[String : AnyObject]] else {
                        throw ErrorManager.jsonError
                    }
                    
                    for forEachOperation in operation {
                        let operationToAppend = FoaasOperation(json: forEachOperation)
                        if let parsedOperation = operationToAppend {
                            operationArr.append(parsedOperation)
                        }
                    }
                    
                    complete(operationArr)
                }
                catch ErrorManager.jsonError {
                    print("ERROR WHEN CONVERTING DATA TO JSON. LOCATION: \(#function)")
                }
                catch {
                    print("ERROR \(error)")
                }
            }
            }.resume()
    }
}
