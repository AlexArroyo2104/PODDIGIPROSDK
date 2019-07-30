//
//  Atributos_wizard.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 17/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_wizard: Atributos_Generales {
    
    //////// Explicacion///////
    public var alineadotexto = "left"                       ////// No aplica //////
    public var campo = "col-md-6 col-sm-6 col-xs-12"        // Si aplica
    public var colorfondoavanzar: String = ""
    public var colorfondofinalizar: String = ""
    public var colorfondoregresar: String = ""
    public var colortextoavanzar: String = ""               // Si aplica
    public var colortextofinalizar: String = ""             // Si aplica
    public var colortextoregresar: String = ""              // Si aplica
    public var decoraciontexto = "none"                     ////// No aplica //////
    public var elementopadre: String = ""                   // Si aplica
    public var estilotexto = "normal"                       ////// No aplica //////
    public var eventos : [Eventos] = []                     // Si aplica
    public var habilitado: Bool = true                      // Si aplica
    public var paginaavanzar = "formElec_element172"        // Si aplica
    public var paginaregresar = "formElec_element151"       // Si aplica
    public var plantillaabrir = ""                          // Si aplica
    public var prefilleddata:NSMutableDictionary = [:]
    public var tareafinalizar = ""                          // Si aplica
    public var textoavanzar = "Avanzar"                     // Si aplica
    public var textofinalizar = "Finalizar"                 // Si aplica
    public var textoregresar = "Regresar"                   // Si aplica
    public var tipoguardado: String = ""                    // Si aplica
    public var validacion = false                           // Si aplica
    public var vericonos: Bool = false
    public var visible = true                               // Si aplica
    public var visibleavanzar = true                        // Si aplica
    public var visiblefinalizar = true                      // Si aplica
    public var visibleregresar = true                       // Si aplica
        
    public var coloravanzar = "btn-default"                 // Si aplica
    public var colorfinalizar = "btn-default"               // Si aplica
    public var colorregresar = "btn-default"                // Si aplica
    public var ayuda: String = ""                           // Si aplica
    public var cerraralfinalizar: Bool = false              // Si aplica
    public var ocultarsubtitulo: Bool = false               // Si aplica
    public var subtitulo: String = ""                       // Si aplica
    
        
}
