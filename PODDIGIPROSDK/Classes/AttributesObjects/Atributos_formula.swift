//
//  Atributos_formula.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/10/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_formula: EVObject{
    
    public var value = ""
    public var type = ""
    public var id = ""
    public var tipo = ""
    
}

public enum Typeformula : String {
    
    // Elementos
    case elementovariable = "elementovariable"
    
    // De propiedad
    case point = "point"
    
    // De valor
    case propiedadvariable = "propiedadvariable"
    
    // Operadores
    case equal = "equal"
    
    // Tipo de asignacion
    case character = "character"

    public var label:String? {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first?.label
    }
    
}
