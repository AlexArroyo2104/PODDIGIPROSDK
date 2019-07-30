//
//  Atributos_tabla.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 9/26/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_tabla: Atributos_Generales{
    
    public var valor: String = ""                       // Si aplica
    public var valormetadato: String = ""               // Si aplica
    public var requerido: Bool = true                   // Si aplica
    public var habilitado: Bool = true                  // Si aplica
    public var visible: Bool = true                     // Si aplica
    public var configcolumnas: String = ""
    public var vertotales: Bool = false                 // Si aplica
    public var filas: Int = 1                           // Si aplica
    public var publicaranexo: Bool = true               // Si aplica
    public var tipodoc: String = ""                     // Si aplica
    public var metadato: String = ""                    // Si aplica
    public var eventos : [Eventos] = []                 // Si aplica
    
    public var campo: String = "";                      // SI aplica
    public var alineadocampo: String = "";              ////// No aplica //////
    public var filasVisibles: Int = 0;                  // Si aplica
    public var ordenFilas: Array<Int> = [0]             // Si aplica
    public var mostrarmensajerequerido: Bool = false;
    public var colorencabezadotabla: String = ""
    public var colorencabezadotextotabla: String = ""
    public var colorheadertexto: String = ""
    public var colorheader: String = ""
    
    //////pendiente revisar atributos de botones
    
    
    
    
    public var alineadotexto: String = ""               ////// No aplica //////
    public var ayuda: String = ""                       // SI aplica
    public var elementopadre: String = ""               // Si aplica
    public var estilotexto: String = ""                 ////// No aplica //////
    public var grosorborde: Int = 1                     ////// No aplica //////
    public var mostrarconsecutivofila: Bool = false     // Si aplica
    public var ocultarsubtitulo: Bool = false           // Si aplica
    public var subtitulo: String = ""                   // Si aplica
    
}
