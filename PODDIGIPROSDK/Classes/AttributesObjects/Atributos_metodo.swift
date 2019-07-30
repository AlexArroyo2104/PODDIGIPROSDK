//
//  Atributos_metodo.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 9/26/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public enum enum_metodo{
    case undefined
    case separarfecha
}

public class Atributos_metodo: Atributos_Generales{
    
    public var tipometodo = ""                  // Si aplica
    public var parametrosentrada = ""           // Si aplica
    public var parametrossalida = ""            // Si aplica
    public var ayuda: String = ""               // Si aplica
    public var elementopadre: String = ""       // Si aplica
    public var ocultarsubtitulo: Bool = false   // SI aplica
    public var subtitulo: String = ""           // Si aplica
    
}
