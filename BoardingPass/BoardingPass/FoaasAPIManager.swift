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
    
    internal func getFoaas(url: URL, completion: @escaping (Foaas) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("ENCOUNTERED ERROR: \(error)")
            }
            if let responseFoaas = response as? HTTPURLResponse {
                print(responseFoaas.statusCode)
            }
            if let validData: Data = data {
                do {
                    let foaasJson = try JSONSerialization.jsonObject(with: validData, options: [])
                    guard let foaasDict = foaasJson as? [String : AnyObject] else {throw ErrorManager.jsonError}
                    if let fooasReturn = Foaas(json: foaasDict) {
                        completion(fooasReturn)
                    }
                }
                catch ErrorManager.jsonError {
                    print("ERROR WHEN CONVERTING DATA TO JSON. LOCATION: getFoaas")
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
                    guard let operation = operationJson as? [[String : AnyObject]] else { throw ErrorManager.jsonError }
                    for forEachOperation in operation {
                        let operationToAppend = FoaasOperation(json: forEachOperation)
                        if let parsedOperation = operationToAppend {
                            operationArr.append(parsedOperation)
                        }
                    }
                complete(operationArr)
                    
                }
                catch ErrorManager.jsonError {
                    print("ERROR WHEN CONVERTING DATA TO JSON. LOCATION: getOperations")
                }
                catch {
                    print("ERROR \(error)")
                }
            }
            }.resume()
    }
}
