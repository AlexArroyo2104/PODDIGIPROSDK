//
//  Atributos.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 25/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos: EVObject{
    public var nombre = "" // si aplica
    
    /*override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.count == 0 || value == "null" {
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            return true
        } else if value is NSNull {
            return true
        }
        return false
    }*/
    
}

public class Atributos_Generales: Atributos{
    
    // Atributos Generales
    public var icono: String = ""                       ////// No aplica //////
    public var titulo: String = ""                      /// si aplica
    public var ocultartitulo: Bool = false              /// si aplica
    public var iscontainer: Bool = false                /// si aplica
    public var mensajerespuestaservicio: String = ""    /// si aplica
    public var mensajerespuestaserviciotipo: String = ""   ////si aplica
    public var ordencampo: Int = 0;                     /// si aplica
}
