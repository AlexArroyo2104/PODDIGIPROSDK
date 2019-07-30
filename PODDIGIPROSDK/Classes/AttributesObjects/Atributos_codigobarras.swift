//
//  Atributos_codigobarras.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 17/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_codigobarras: Atributos_Generales {
    
    public var alineadotexto: String = ""                       ////// No aplica //////
    public var alto: Int = 50
    public var ancho: Int = 120
    public var ayuda: String = ""                               // Si aplica
    public var campo: String = "col-md-12 col-sm-12 col-xs-12"  // Si aplica
    public var decoraciontexto: String = ""                     ////// No aplica //////
    public var elementopadre: String = ""                       // Si aplica
    public var estilotexto: String = ""                         /////// No aplica //////
    public var eventos: [Eventos] = []                          // Si aplica
    public var expresionregular: String = ""
    public var generarcodigo: Bool = true                       // Si aplica
    public var habilitado: Bool = true                          // Si aplica
    public var mayusculasminusculas: String = "normal"          // Si aplica
    public var metadato: String = ""                            // Si aplica
    public var ocultarsubtitulo: Bool = false                   // Si aplica
    public var pdfcampo: String = ""                            ////// No aplica //////
    public var pdfcampocodigo: String = ""                      ////// No aplica //////
    public var regexconfigmsg: String = ""
    public var regexrerror: Bool = false
    public var regexrerrormsg: String = ""
    public var requerido: Bool = false                          // Si aplica
    public var subtitulo: String = ""                           // Si aplica
    public var tipocodigo: String = "Code 128"                  // Si aplica
    public var valor: String = ""                               // Si aplica
    public var valormetadato: String = ""                       // Si aplica
    public var visible: Bool = true                             // Si aplica
    
    
    public var alineadocampo: String = "vertical"               ////// No aplica //////
    public var mostrarmensajerequerido: Bool = false
    
}
