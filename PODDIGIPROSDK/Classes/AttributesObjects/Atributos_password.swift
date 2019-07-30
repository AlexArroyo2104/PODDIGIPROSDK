//
//  Atributos_password.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 17/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_password: Atributos_Generales {
    
    public var alineadocampo: String = "vertical"               ////// No aplica //////
    public var alineadotexto: String = "left"                   ////// No aplica //////
    public var campo: String = "col-md-6 col-sm-6 col-xs-12"    // SI aplica
    public var decoraciontexto: String = "none"                 ////// No aplica //////
    public var estilotexto: String = "normal"                   ////// No aplica //////
    public var eventos: [Eventos] = []                          // Si aplica
    public var expresionregular: String = ""                    // Si aplica
    public var habilitado: Bool = true                          // Si aplica
    public var longitudmaxima: Int = 30                         // Si aplica
    public var longitudminima: Int = 0                          // Si aplica
    public var mascara: String = ""                             // Si aplica
    public var metadato: String = ""                            // Si aplica
    public var regexrerror: Bool = false                        // Si aplica
    public var regexrerrormsg: String = ""                      // Si aplica
    public var requerido: Bool = false                          // Si aplica
    public var valor: String = ""                               // Si aplica
    public var valormetadato: String = ""                       // Si aplica
    public var visible: Bool = true                             // SI aplica
    
    public var mostrarmensajerequerido: Bool = false;
    public var mostrarmensajelonmax: Bool = false;
    public var mostrarmensajelonmin: Bool = false;
    public var mostrarmensajeexpreg: Bool = false;
    
    
    public var ayuda: String = ""                               // SI aplica
    public var elementopadre: String = ""                       // Si aplica
    public var ocultarsubtitulo: Bool = false                   // Si aplica
    public var subtitulo: String = ""                           // Si aplica
    public var regexconfigmsg: String = ""                      // Si aplica
    
}
