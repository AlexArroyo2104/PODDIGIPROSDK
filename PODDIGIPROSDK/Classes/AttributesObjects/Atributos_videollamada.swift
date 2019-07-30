//
//  Atributos_videollamada.swift
//  DGFmwrk
//
//  Created by Jonathan Viloria M on 1/8/19.
//  Copyright © 2019 Digipro Movil. All rights reserved.
//

import Foundation

public class Atributos_videollamada: Atributos_Generales{
    
    public var requerido: Bool = false;
    public var habilitado: Bool = false;
    public var visible: Bool = false;
    public var video: String = "";
    public var grabarvideo: Bool = false;
    public var eventos: [Eventos] = []
    
    public var campo: String = "";
    public var alineadocampo: String = "";
    public var alineadotexto: String = "";
    
}
