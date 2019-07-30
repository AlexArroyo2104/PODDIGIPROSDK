//
//  Elemento.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 25/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class Elemento: EVObject {
    
    public var __name = ""
    public var _idelemento = ""
    public var _tipoelemento = ""
    public var atributos: Any?
    public var elementos: Elementos?
    public var validacion = Validacion()
    public var estadisticas: FEEstadistica? = nil
    
    public override func setValue(_ value: Any!, forUndefinedKey key: String) {
        
        guard let dict = value as? NSDictionary else{
            return
        }
        
        switch _tipoelemento {
        case "eventos":
            break
        case "plantilla":
            self.atributos = Atributos_plantilla(dictionary: dict)
            break
        case "pagina":
            self.atributos = Atributos_pagina(dictionary: dict)
            break
        case "audio", "voz":
            self.atributos = Atributos_audio(dictionary: dict)
            break
        case "boton":
            self.atributos = Atributos_boton(dictionary: dict)
            break
        case "capturafacial":
            self.atributos = Atributos_capturafacial(dictionary: dict)
            break
        case "codigobarras":
            self.atributos = Atributos_codigobarras(dictionary: dict)
            break
        case "fecha":
            self.atributos = Atributos_fecha(dictionary: dict)
            break
        case "firma":
            self.atributos = Atributos_firma(dictionary: dict)
            break
        case "georeferencia":
            self.atributos = Atributos_georeferencia(dictionary: dict)
            break
        case "hora":
            self.atributos = Atributos_hora(dictionary: dict)
            break
        case "huelladigital":
            self.atributos = Atributos_huelladigital(dictionary: dict)
            break
        case "imagen":
            self.atributos = Atributos_imagen(dictionary: dict)
            break
        case "leyenda":
            self.atributos = Atributos_leyenda(dictionary: dict)
            break
        case "lista":
            self.atributos = Atributos_lista(dictionary: dict)
            break
        case "comboboxtemporal":
            self.atributos = Atributos_listatemporal(dictionary: dict)
            break
        case "logico":
            self.atributos = Atributos_logico(dictionary: dict)
            break
        case "deslizante":
            self.atributos = Atributos_Slider(dictionary: dict)
            break
        case "logo":
            self.atributos = Atributos_logo(dictionary: dict)
            break
        case "mapa":
            self.atributos = Atributos_mapa(dictionary: dict)
            break
        case "metodo":
            self.atributos = Atributos_metodo(dictionary: dict)
            break
        case "moneda":
            self.atributos = Atributos_moneda(dictionary: dict)
            break
        case "numero":
            self.atributos = Atributos_numero(dictionary: dict)
            break
        case "password":
            self.atributos = Atributos_password(dictionary: dict)
            break
        case "rangofechas":
            self.atributos = Atributos_rangofechas(dictionary: dict)
            break
        case "seccion":
            self.atributos = Atributos_seccion(dictionary: dict)
            break
        case "servicio":
            self.atributos = Atributos_servicio(dictionary: dict)
            break
        case "tabla":
            self.atributos = Atributos_tabla(dictionary: dict)
            break
        case "texto":
            self.atributos = Atributos_texto(dictionary: dict)
            break
        case "textarea":
            self.atributos = Atributos_textarea(dictionary: dict)
            break
        case "video":
            self.atributos = Atributos_video(dictionary: dict)
            break
        case "wizard":
            self.atributos = Atributos_wizard(dictionary: dict)
            break
        case "rostrovivo":
            self.atributos = Atributos_rostrovivo(dictionary: dict)
            break
        case "tabber":
            self.atributos = Atributos_tabber(dictionary: dict)
            break
        case "espacio":
            self.atributos = Atributos_espacio(dictionary: dict)
            break
        case "semaforotiempo":
            self.atributos = Atributos_semaforotiempo(dictionary: dict)
            break
        case "calculadorafinanciera":
            self.atributos = Atributos_calculadora(dictionary: dict)
            break
        default:
            break
        }
        
    }
    
    /*override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.count == 0 || value == "null" {
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            return true
        } else if value is NSNull {
            return true
        }
        return false
    }*/
    
}

public class Elementos: EVObject{
    public var elemento: Array<Elemento> = []
    
    /*override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.count == 0 || value == "null" {
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            return true
        } else if value is NSNull {
            return true
        }
        return false
    }*/
}

public class Validacion: EVObject{
    
    public var id = ""
    public var coordenadasplantilla = ""
    public var docid = ""
    public var habilitado = false
    public var valor = ""
    public var valormetadato = ""
    public var visible = false
    public var needsValidation = false
    public var validado = false
    public var anexos: [(id: String, url: String)]?
    
    /*override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.count == 0 || value == "null" {
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            return true
        } else if value is NSNull {
            return true
        }
        return false
    }*/
}
