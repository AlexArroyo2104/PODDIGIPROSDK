//
//  Atributos_servicio.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 9/26/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public enum enum_servicio{
    case undefined
    case sepomex
    case enrollfinger
    case verifyfinger
    case identifyfinger
    case enrollface
    case verifyface
    case identifyface
    case comparefaces
    case ocrine
    case ocrcfe
    case ocrtelmex
    case ocrcea
    case ocratt
    case inebydata
    case inebyfinger
    case sendsms
    case validatesmscode
    case obtenercurp
    case validarcurp
    case confirmmail
    case callvideochat
    case saassirh
    case folioautomatico
}

public class Atributos_servicio: Atributos_Generales{
    
    public var tiposervicio: String = ""            // Si aplica
    public var parametrosentrada: String = ""       // Si aplica
    public var parametrossalida: String = ""        // Si aplica
    public var mensajeservicio: String = ""         // Si aplica
    public var requerido: Bool = false              // Si aplica
    public var respuestacorrecta: Bool = false      // Si aplica
    
    public var mensajeerrorservicio: String = "";
    public var mensajeexitoservicio: String = "";
    
    
    
    public var ayuda: String = ""                   // Si aplica
    public var elementopadre: String = ""           // Si aplica
    public var ocultarsubtitulo: Bool = false       // Si aplicxa
    public var subtitulo: String = ""               // Si aplica
    
}
