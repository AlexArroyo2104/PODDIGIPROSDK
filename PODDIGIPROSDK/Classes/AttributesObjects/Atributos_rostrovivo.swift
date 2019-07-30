//
//  Atributos_rostrovivo.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 11/20/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_rostrovivo: Atributos_Generales{
    
    public var alineadocampo: String = ""               ////// No aplica //////
    public var alineadotexto: String = ""               ////// No aplica //////
    public var campo: String = ""                       // SI aplica
    public var decoraciontexto: String = ""             ////// No aplica //////
    public var docid: Int = 0
    public var estilotexto: String = ""                 // SI aplica
    public var eventos: [Eventos] = []                  // Si aplica
    public var habilitado: Bool = false                 // Si aplica
    public var incluirenpdf: Bool = false               ////// No aplica //////
    public var nombrearchivo: String = ""               // SI aplica
    public var pdfcampoanexo: String = ""               ////// No aplica //////
    public var proveedor: String = "" //faceplusplus, veridium // Si aplica
    public var requerido: Bool = false                  // Si aplica
    public var tipodoc: String = ""                     // Si aplica
    public var visible: Bool = false                    // Si aplica
    
    public var anteriorguid: String = "";
    public var anteriordocid: String = "";
    public var mostrarmensajerequerido: Bool = false;
    public var downloadanexo: Bool = false;
    public var isliveperson: String = "";
    public var facetocompare: String = "";
    
    
    
    public var anteriornombrearchivo: String = ""       // Si aplica
    public var ayuda: String = ""                       // Si aplica
    public var elementopadre: String = ""               // Si aplica
    public var ocultarsubtitulo: Bool = false           // Si aplica
    public var subtitulo: String = ""                   // Si aplica
    
    
}
