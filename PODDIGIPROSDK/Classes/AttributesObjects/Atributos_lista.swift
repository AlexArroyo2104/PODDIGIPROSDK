//
//  Atributos_lista.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 13/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_lista: Atributos_Generales {
    
    public var alineadotexto: String = "";              ////// No aplica //////
    public var ayuda: String = ""                       // Si aplica
    public var campo: String = "";                      // Si aplica
    public var cascadahijo: String = "";                // Si aplica
    public var cascadapadre: Bool = false;              // Si aplica
    public var catalogoorigen: String = ""              // Si aplica
    public var catalogodestino: Bool = false            // Si aplica
    public var catalogossistema: String = ""            // Si aplica
    public var configjson: Bool = true                  // Si aplica
    public var configuracioncascada: String = ""
    public var decoraciontexto: String = "";            ////// No aplica //////
    public var elementopadre: String = "";              // Si aplica
    public var estilotexto: String = "";                ////// No aplica //////
    public var eventos: [Eventos] = []                  // Si aplica
    public var filtrarcatalogo: FiltrarCatalogo = FiltrarCatalogo()
    public var fuentedatos: String = "";                // Si aplica
    public var grosortexto: String = "";                ////// No aplica //////
    public var habilitado: Bool = true                  // Si aplica
    public var maxopcionesseleccionar: Int = 1          // Si aplica
    public var metadato: String = ""                    // Si aplica
    public var minopcionesseleccionar: Int = 1          // Si aplica
    public var ocultarsubtitulo: Bool = false           // Si aplica
    public var ordenitems: String = ""                  // Si aplica
    public var orientacion: String = "";                // Si aplica
    public var pdfcampo: String = ""                    ////// No aplica //////
    public var requerido: Bool = false                  // Si aplica
    public var subtitulo: String = ""                   // Si aplica
    public var textoconid: String = ""                  // Si aplica
    public var tieneesquema: Bool = false               // Si aplica
    public var tipoasociacion: String = ""              // Si aplica
    public var tipolista: String = ""                   // Si aplica
    public var valor: String = ""                       // Si aplica
    public var valormetadato: Bool = false              // Si aplica
    public var valorlista: Bool = false                 // Si aplica
    public var visible: Bool = true                     // Si aplica
   
    
    /*public var mascara: String = ""                     /// Explicacion
    public var catalogodestinoobject: Bool = false      // Si aplica
    public var chosenitems: Bool = false                // Si aplica
    public var optionselected: Bool = false             // Si aplica
    public var usarcomocampoexterno: Bool = false       // Si aplica
    public var usarcomoresumen: Bool = false            // Si aplica
    public var ordenenresumen: Int = 1                  // Si aplica
    public var elementoprellenadoexterno: String = ""   // Si aplica
    public var alineadocampo: String = "";              ////// No aplica //////
    public var esprimeravezchanged: Bool = true;
    public var esprimeravezevento: Bool = true;
    public var esprimeravezpintado: Bool = true;
    public var addlistcascadaph: Bool = true;
    public var updateitems: Bool = false;
    public var mostrarmensajerequerido: Bool = false;*/
    
    
}

public class FiltrarCatalogo: EVObject {

    public var filtrar: Bool = false
    public var idfiltrados: String = ""
    public var rangofiltrado: String = ""
    
}
