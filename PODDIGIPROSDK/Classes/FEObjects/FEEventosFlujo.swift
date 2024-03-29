//
//  FEEventosFlujo.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 23/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class FEEventosFlujo: EVObject {
    public var FlujoID = 0;
    public var NombreFlujo = "";
    public var Descripcion = "";
    public var EstadoIniId = 0;
    public var EstadoFinId = 0;
    public var EstadoFinal = "";
    public var TareaID = 0;
    public var NombreTarea = "";
    public var EventoId = 0;
    public var ProcesoID = 0;
    public var NombreProceso = "";
    public var PIID = 0;
    public var Total = 0;
    public var seleccionadoFlujo = false;
    
    override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.count == 0 || value == "null" {
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            return true
        } else if value is NSNull {
            return true
        }
        return false
    }
}
