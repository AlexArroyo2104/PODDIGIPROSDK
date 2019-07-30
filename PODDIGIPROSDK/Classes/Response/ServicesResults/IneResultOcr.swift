//
//  IneResultOcr.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 10/17/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class IneResultOcr: EVObject{
    
    public var anchornombre = ""
    public var anchordomicilio = ""
    public var anchorcurp = ""
    public var anchorseccion = ""
    public var anchorOCR = ""
    public var anchorcic = ""
    public var anchorclaveelector = ""
    public var anchorestado = ""
    public var anchorvigencia = ""
    public var anchorEmision = ""
    public var anchorLocalidad = ""
    public var nombreDetectado = false
    public var domicilioDetectado = false
    public var curpDetectado = false
    public var seccionDetectado = false
    public var ocrDetectado = false
    public var cicDetectado = false
    public var claveElectorDetectado = false
    public var estadoNumDetectado = false
    public var estadoDetectado = false
    public var emisionDetectado = false
    public var vigenciaDetectado = false
    public var motor = ""
    public var nombre = ""
    public var isNombreValid = false
    public var aPaterno = ""
    public var isaPaternoValid = false
    public var aMaterno = ""
    public var isaMaternoValid = false
    public var calle = ""
    public var isCalleValid = false
    public var colonia = ""
    public var isColoniaValid = false
    public var delegacion = ""
    public var isDelegacionValid = false
    public var cP = ""
    public var iscPValid = false
    public var curp = ""
    public var isCurpValid = false
    public var seccion = ""
    public var isSeccionValid = false
    public var ocr = ""
    public var isOcrValid = false
    public var cic = ""
    public var isCicValid = false
    public var claveElector = ""
    public var isClaveElectorValid = false
    public var estado = ""
    public var isEstadoValid = false
    public var estadoNum = ""
    public var isEstadoNumValid = false
    public var vigencia = ""
    public var isVigenciaValid = false
    public var detectados = 0
    public var totales = 0
    public var obtenerFrontal = false
    public var obtenerReverso = false
    public var emision = ""
    public var isEmisionValid = false
    
}
