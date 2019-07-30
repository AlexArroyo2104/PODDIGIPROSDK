//
//  Atributos_hora.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 16/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_hora: Atributos_Generales {
    
    public var alineadocampo: String = "vertical"               ////// No aplica //////
    public var alineadotexto: String = "left"                   ////// No aplica //////
    public var campo: String = "col-md-6 col-sm-6 col-xs-12"    // Si aplica
    public var decoraciontexto: String = "none"                 ////// No aplica //////
    public var elementoprellenadoexterno: Array<String> = [""] // Si aplica
    public var estilotexto: String = "normal"                   ////// No aplica //////
    public var eventos: [Eventos] = []                          // Si aplica
    public var habilitado: Bool = true                          // Si aplica
    public var hora: String = "H:i"                             // Si aplica
    public var mascara: String = ""                             // Si aplica
    public var metadato: String = ""                            // Si aplica
    public var ordenenresumen: Int = 0                          // Si aplica
    public var pdfcampo: String = ""                            ////// No aplica //////
    public var requerido: Bool = false                          // Si aplica
    public var usarcomocampoexterno: Bool = false               // Si aplica
    public var usarcomoresumen: Bool = false                    // Si aplica
    public var valor: String = ""                               // Si aplica
    public var valormetadato: String = ""                       // Si aplica
    public var visible: Bool = true                             // Si aplica
    
    public var mostrarmensajerequerido: Bool = false
    public var ayuda: String = ""                               // Si aplica
    public var ocultarsubtitulo: Bool = false                   // Si aplica
    public var subtitulo: String = ""                           // Si aplica
    public var elementopadre: String = ""                       // Si aplica
    
}
