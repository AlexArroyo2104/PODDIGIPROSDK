//
//  FEFormatoData.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 30/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class FEFormatoData: EVObject{
    
    public var Guid = ""
    public var InstanciaId = 0
    public var DocID = 0
    public var ExpID = 0
    public var NombreExpediente = ""
    public var TipoDocID = 0
    public var NombreTipoDoc = ""
    public var EstadoID = 0
    public var NombreEstado = ""
    public var Usuario = ""
    public var FlujoID = 0
    public var NombreFlujo = ""
    public var ProcesoID = 0
    public var NombreProceso = ""
    public var PIID = 0
    public var EstadoApp = 0
    public var CoordenadasFormato = ""
    public var JsonDatos = ""
    public var Xml = ""
    public var Anexos = Array<FEAnexoData>()
    public var AnexosBorrados = Array<String>()
    public var Estadisticas =  Array<FEEstadistica>()
    public var TareaSiguiente = FEEventosFlujo()
    public var Movil = true
    public var Reserva = false
    public var Enviado = false
    public var Borrador = false
    public var porEnviar = false
    public var TipoReemplazo = 0
    public var Accion = 0
    public var Resumen = ""
    public var editado = false
    public var ShowLog = false
    public var ShowLogTransitando = false
    public var ShowLogEnviando = false
    public var ShowLogDownloadAnexos = false
    public var estatusEnvio = 0
    public var estatusTransitando = 0
    public var AnexosDescargados = false
    public var isSelected = false
    public var FechaFormatoLong = 0
    public var FechaFormato = ""
    public var TipoRemplazo = 0
    //public var FechaActualizacion = ""
    //public var FechaInstancia = ""
    
    override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if key == "FechaActualizacion"{
            return true
        }else if key == "FechaInstancia"{
            return true
        }else{
            if let value = value as? String, value.count == 0 || value == "null" {
                return true
            } else if let value = value as? NSArray, value.count == 0 {
                return true
            } else if value is NSNull {
                return true
            }
        }
        return false
    }
}
