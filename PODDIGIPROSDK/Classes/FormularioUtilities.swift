//
//  FormularioUtilities.swift
//  DIGIPROSDK
//
//  Created by Jonathan Viloria M on 5/3/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import Foundation

@objc public protocol FormularioUtilitiesDelegate: class {
    
}

public final class FormularioManager<Delegate: FormularioUtilitiesDelegate>: NSObject {
    public weak var delegate: Delegate?
}

public class FormularioUtilities{
    
    public static let shared = FormularioUtilities()
    
    public var currentFormato = FEFormatoData()
    public var currentAnexos = [FEAnexoData]()
    public var atributosPaginas = [Atributos_pagina]()
    public var paginasVisibles = [Atributos_pagina]()
    
    public var globalFlujo = 0
    public var globalIndexFlujo = 0
    public var globalProceso = 0
    public var globalIndexProceso = 0
    
    public var elemenstInPlantilla = [(id: String, type: String, kind: Any?, element: Elemento?)]()
    
    public func operaciones(_ a: String, _ b: String, _ t: String) -> String{
        var a = a
        var b = b
        let aIsNumber = Double(a) != nil ? true : false
        let bIsNumber = Double(b) != nil ? true : false
        switch (t) {
        case "-":
            if !aIsNumber || !bIsNumber{
                return "\(a) \(b)"
            }else{
                return String(Double(Double(a)! - Double(b)!))
            }
        case "+":
            if !aIsNumber || !bIsNumber{
                return "\(a) \(b)"
            }else{
                return String(Double(Double(a)! + Double(b)!))
            }
        case "/":
            if !aIsNumber || !bIsNumber{
                return "\(a) \(b)"
            }else{
                return String(Double(Double(a)! / Double(b)!))
            }
        case "*":
            if !aIsNumber || !bIsNumber{
                return "\(a) \(b)"
            }else{
                return String(Double(Double(a)! * Double(b)!))
            }
        case "^":
            if !aIsNumber || !bIsNumber{
                return "\(a) \(b)"
            }else{
                return String(Double(pow(Double(a)!, Double(b)!)))
            }
        case "=":
            if !aIsNumber && !bIsNumber{
                let logicString = a.lowercased() == b.lowercased()
                return logicString ? "true" : "false"
            }else if aIsNumber || bIsNumber{
                if a == "0"{
                    a = "false"
                }else if a == "1"{
                    a = "true"
                }
                if b == "0"{
                    b = "false"
                }else if b == "1"{
                    b = "true"
                }
                let logicString = a.lowercased() == b.lowercased()
                return logicString ? "true" : "false"
            }else{
                let aString = String(a)
                let bSgtring = String(b)
                let logicString = aString.lowercased() == bSgtring.lowercased()
                return logicString ? "true" : "false"
            }
        case "&&":
            let aString = String(a)
            let bSgtring = String(b)
            let logicString = returnLogicParameter(aString) && returnLogicParameter(bSgtring)
            return logicString ? "true" : "false"
        case "||":
            let aString = String(a)
            let bSgtring = String(b)
            let logicString = returnLogicParameter(aString) || returnLogicParameter(bSgtring)
            return logicString ? "true" : "false"
        case ">":
            let aString = Int(a)
            let bSgtring = Int(b)
            let logicInt = aString! > bSgtring!
            return logicInt ? "true" : "false"
        case "<":
            let aString = Int(a)
            let bSgtring = Int(b)
            let logicInt = aString! < bSgtring!
            return logicInt ? "true" : "false"
        case ">=":
            let aString = Int(a)
            let bSgtring = Int(b)
            let logicInt = aString! >= bSgtring!
            return logicInt ? "true" : "false"
        case "<=":
            let aString = Int(a)
            let bSgtring = Int(b)
            let logicInt = aString! <= bSgtring!
            return logicInt ? "true" : "false"
        default:
            return "0"
        }
    }
    
    public func variables(_ token: [Formula]) -> String{
        if token[0].value == "Hoy"{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        if token[0].value == "Ahora"{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        if token[0].value == "Celular"{
            return "CelularVariable"
        }
        if token[0].value == "Correo"{
            return "CorreoVariable"
        }
        if token[0].value == "Si"{
            return "si"
        }
        if token[0].value == "No"{
            return "no"
        }
        if token[0].value == "Y tambien"{
            return "&&";
        }
        if token[0].value == "Ó tambien"{
            return "||"
        }
        if token[0].value == "NuevoDocumento" && FormularioUtilities.shared.currentFormato.DocID == 0{
            return "si"
        }
        if token[0].value == "NuevoDocumento" && FormularioUtilities.shared.currentFormato.DocID != 0{
            return "no"
        }
        if token[0].value == "EstadoDocumento" {
            for variable in ConfigurationManager.shared.variablesDataUIAppDelegate.ListVariables {
                // Getting value from Documento
                let id = token[2].value.split{$0 == "-"}.map(String.init)
                if id[1] == variable.Valor, variable.Valor == String(FormularioUtilities.shared.currentFormato.EstadoID) {
                    return "si"
                }
            }
            return "no"
        }
        for variable in ConfigurationManager.shared.variablesDataUIAppDelegate.ListVariables {
            if variable.Nombre == token[0].value {
                return variable.Valor;
            }
        }
        return token[0].value
    }
    
    public func returnLogicParameter(_ value: String) -> Bool{
        if value == "true"{
            return true
        }
        if value == "false"{
            return false
        }
        let a1 = Int(value) != nil ? Int(value)! : 0
        return a1 > 0
    }
    
    public func checkIfElementIsVisible(_ elem: Elemento) -> Bool{
        
        // Assinging to TipoElemento Enum
        let tipoElemento = TipoElemento(rawValue: "\(elem._tipoelemento)") ?? TipoElemento.other
        
        switch tipoElemento {
        case TipoElemento.plantilla:
            return false
        case TipoElemento.pagina:
            let atr = elem.atributos as! Atributos_pagina
            return atr.visible
        case TipoElemento.seccion:
            let atr = elem.atributos as! Atributos_seccion
            return atr.visible
        case TipoElemento.texto:
            let atr = elem.atributos as! Atributos_texto
            return atr.visible
        case TipoElemento.numero:
            let atr = elem.atributos as! Atributos_numero
            return atr.visible
        case TipoElemento.textarea:
            let atr = elem.atributos as! Atributos_textarea
            return atr.visible
        case TipoElemento.password:
            let atr = elem.atributos as! Atributos_password
            return atr.visible
        case TipoElemento.moneda:
            let atr = elem.atributos as! Atributos_moneda
            return atr.visible
        case TipoElemento.boton:
            let atr = elem.atributos as! Atributos_boton
            return atr.visible
        case TipoElemento.fecha:
            let atr = elem.atributos as! Atributos_fecha
            return atr.visible
        case TipoElemento.hora:
            let atr = elem.atributos as! Atributos_hora
            return atr.visible
        case TipoElemento.leyenda:
            let atr = elem.atributos as! Atributos_leyenda
            return atr.visible
        case TipoElemento.logico:
            let atr = elem.atributos as! Atributos_logico
            return atr.visible
        case TipoElemento.slider:
            let atr = elem.atributos as! Atributos_Slider
            return atr.visible
        case TipoElemento.logo:
            let atr = elem.atributos as! Atributos_logo
            return atr.visible
        case TipoElemento.firma:
            let atr = elem.atributos as! Atributos_firma
            return atr.visible
        case TipoElemento.imagen:
            let atr = elem.atributos as! Atributos_imagen
            return atr.visible
        case TipoElemento.audio:
            let atr = elem.atributos as! Atributos_audio
            return atr.visible
        case TipoElemento.video:
            let atr = elem.atributos as! Atributos_video
            return atr.visible
        case TipoElemento.mapa:
            let atr = elem.atributos as! Atributos_mapa
            return atr.visible
        case TipoElemento.lista:
            let atr = elem.atributos as! Atributos_lista
            return atr.visible
        case TipoElemento.listatemporal:
            let atr = elem.atributos as! Atributos_listatemporal
            return atr.visible
        case TipoElemento.wizard:
            let atr = elem.atributos as! Atributos_wizard
            return atr.visible
        case TipoElemento.codigobarras:
            let atr = elem.atributos as! Atributos_codigobarras
            return atr.visible
        case TipoElemento.huelladigital:
            let atr = elem.atributos as! Atributos_huelladigital
            return atr.visible
        default:
            return false
        }
    }
}
