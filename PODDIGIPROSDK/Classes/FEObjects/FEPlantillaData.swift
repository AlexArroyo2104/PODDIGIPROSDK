//
//  FEPlantillaData.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 23/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class FEPlantillaData: EVObject {
    public var ExpID = 0;
    public var FechaActualizacion = ""
    public var NombreExpediente = "";
    public var MostrarExp = false;
    public var TipoDocID = 0;
    public var MostrarTipoDoc = false;
    public var NombreTipoDoc = "";
    public var XmlPlantilla = ""
    public var UsarCoordenadas = "";
    public var FlujoID = 0;
    public var NombreFlujo = "";
    public var EventosTareas = Array<FEEventosFlujo>()
    public var ListVariables = Array<FEVariableData>()
    
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
