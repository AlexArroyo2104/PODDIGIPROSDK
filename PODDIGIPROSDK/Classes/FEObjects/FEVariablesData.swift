//
//  FEVariablesData.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/23/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class FEVariablesData: EVObject{
    public var AplicacionID = 0
    public var ProyectoID = 0
    public var ListVariables = Array<FEVariableData>()
    public var IP = ""
    public var Password = ""
    public var User = ""
    public var ListLog: Array<FELogError> = [FELogError]()
    public var LogsSincronizados = false
    
    override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.count == 0 || value == "null" {
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            return true
        } else if value is NSNull {
            return true
        }
        return false
    }
}
