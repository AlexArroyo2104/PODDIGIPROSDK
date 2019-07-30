//
//  Atributos_huelladigital.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 17/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_huelladigital: Atributos_Generales {
    
    public var alineadocampo: String = "vertical"               ////// No aplica //////
    public var alineadotexto: String = "left"                   ////// No aplica //////
    public var campo: String = "col-md-12 col-sm-12 col-xs-12"  // Si aplica
    public var decoraciontexto: String = "none"                 ////// No aplica //////
    public var docid: String = ""                               // Si aplica
    public var estilotexto: String = "normal"                   // Si aplica
    public var eventos: [Eventos] = []                          // Si aplica
    public var fingernumber: Int = 0                            // Si aplica
    public var habilitado: Bool = true                          // Si aplica
    public var nombrearchivo: String = ""                       // Si aplica
    public var requerido: Bool = false                          // Si aplica
    public var tipoescaneo: String = "enroll"                   // Si aplica
    public var tipoescaner: String = "futronic"                 //futronic, morpho, veridium // Si aplica
    public var visible: Bool = true                             // Si aplica
    
    public var tipodoc: String = "";                            // Si aplica
    public var cantidadhuellas: String = "0";                   // Si aplica
    public var scorepromedio: String = "";                      // Si aplica
    public var scorehuellas: String = "";                       // Si aplica
    
    public var huellascapturadasr: String = "";
    public var huellascapturadasl: String = "";
    
    public var verscore: Bool = false;                          // Si aplica
    public var scoremin: String = "";                           // Si aplica
    public var huellasacapturar: String = "";                   // Si aplica
    
    public var mostrarmensajerequerido: Bool = false;
    
    public var anteriornombrearchivo: String = ""               // Si aplica
    public var ayuda: String = ""                               // Si aplica
    public var ocultarsubtitulo: Bool = false                   // Si aplica
    public var subtitulo: String = ""                           // Si aplica
    public var elementopadre: String = ""                       // Si aplica
    
}
