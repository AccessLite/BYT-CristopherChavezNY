//
//  FoaasField.swift
//  BoardingPass
//
//  Created by Cris on 11/24/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
enum FieldErrorHandling: Error {
    case FieldName, FieldField
}
struct FoaasField: JSONConvertible, CustomStringConvertible {
    let fieldsName: String
    let fieldsField: String
    var description: String {
        return "\(fieldsName) \(fieldsField)"
    }
    init?(json: [String : Any]) {
        do {
            guard let fieldName = json["name"] as? String else { throw FieldErrorHandling.FieldName }
            guard let fieldsField = json["field"] as? String else { throw FieldErrorHandling.FieldField }
            self.fieldsName = fieldName
            self.fieldsField = fieldsField
        }
        catch FieldErrorHandling.FieldName {
            print("ERROR OCCURED WHILE PARSING FeldsName")
        }
        catch FieldErrorHandling.FieldField {
            print("ERROR OCCURED WHILE PARSING FieldsField")
        }
        catch {
            print("ERROR OCCURED: \(error)")
        }
        return nil
    }
    func toJson() -> [String : Any] {
        let dictToReturn: [ String : Any] = [
            "fieldsName" : self.fieldsName,
            "fieldsField" : self.fieldsField,
            "description" : self.description
        ]
        return dictToReturn
    }
}
