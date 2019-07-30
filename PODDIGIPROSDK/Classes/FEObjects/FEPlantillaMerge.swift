//
//  FEPlantillaMerge.swift
//  DGFmwrk
//
//  Created by Jonathan Viloria M on 1/21/19.
//  Copyright © 2019 Digipro Movil. All rights reserved.
//

import Foundation

public class FEPlantillaMerge: EVObject {
    public var FlujoID = 0 // Flujo
    
    public var ExpID = 0
    public var TipoDocID = 0
    
    public var MostrarExp = false;
    public var MostrarTipoDoc = false;
    
    public var FechaActualizacion = ""
    public var NombreFlujo = ""
    
    public var Procesos = Array<String>()
    public var PProcesos = [FEProcesos]()
    public var ExpDoc = [FEExpDoc]()

}
