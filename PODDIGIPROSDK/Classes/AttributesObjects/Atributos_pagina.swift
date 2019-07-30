//
//  Atributos_pagina.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 26/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_pagina: Atributos_Generales{
    
    public var eventos: [Eventos] = []               //Si aplica
    public var ocultarsubtitulo: Bool = false        //si aplica
    public var habilitado: Bool = false              //si aplica
    public var visible: Bool = false                 //si aplica
    public var validado: Bool = false                //si aplica
    public var paginaseleccionada: Bool = false;     //si aplica
    public var disableAll: Bool = false;             //si aplica
    public var elementopadre: String = ""            //Si aplica
    public var subtitulo: String = ""                //si aplica
    public var ayuda: String = ""                    //si aplica
    
    
    ////////////////Variables Adicionales///////////////////
    
    public var campostotales: Int = 0
    public var camposobligatorios: Int = 0
    public var camposerrores: Int = 0
    public var click: Bool = false;
    public var time: String = "00:00"
    
}
