//
//  TipoElemento.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 25/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

// ENUMS ERRORTYPE
enum serverError: Swift.Error {
    case runtimeError(String)
}

public enum errorType: String {
    case dflt = "Default"
    case warning = "Warning"
    case danger = "Danger"
    case success = "Success"
}

// ENUMS HTTPMETHOD
public enum httpMethod: String{
    case POST = "POST"
    case GET = "GET"
}

public enum ErrorPromise: Swift.Error {
    case rejectError
}

// ENUMS HTTPCONNECTIONS
public enum httpConnection: String{
    case access = "https://cloud.digipromovil.com/WCFCodigo/WcfCodigo.svc"
    case debug = "http://192.168.201.3:5001/app.svc"
}

public enum TipoElemento : String {
    
    case eventos = "eventos"
    
    case plantilla = "plantilla"
    case pagina = "pagina"
    
    case audio = "audio"
    case boton = "boton"
    case capturafacial = "capturaFacial"
    case codigobarras = "codigobarras"
    case fecha = "fecha"
    case firma = "firma"
    case georeferencia = "georeferencia"
    case hora = "hora"
    case huelladigital = "huelladigital"
    case imagen = "imagen"
    case leyenda = "leyenda"
    case lista = "lista"
    case logico = "logico"
    case logo = "logo"
    case mapa = "mapa"
    case metodo = "metodo"
    case moneda = "moneda"
    case numero = "numero"
    case password = "password"
    case rangofechas = "rangoFechas"
    case seccion = "seccion"
    case servicio = "servicio"
    case tabla = "tabla"
    case texto = "texto"
    case textarea = "textarea"
    case video = "video"
    case wizard = "wizard"
    case rostrovivo = "rostrovivo"
    case videollamada = "videollamada"
    case slider = "deslizante"
    case listatemporal = "comboboxtemporal"
    case calculadora = "calculadorafinanciera"
    
    case tabber = "tabber"
    case espacio = "espacio"
    case semaforotiempo = "semaforotiempo"
    
    case other = ""
    
    var label:String? {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first?.label
    }

}


public enum InternetConnectionError: Error{
    case Unavailable
    case Connected
    case NoConnected
}

public enum APIErrorResponse: Error{
    
    case InternetConnectionError
    
    case DetectLicenceError
    // ERRORS FOR ONLINE
    case CodigoOnlineError
    case SkinOnlineError
    case UsuarioOnlineError
    case PlantillasOnlineError
    case VariablesOnlineError
    case FormatosOnlineError
    case FlujosAndProcesosOnlineError
    
    case RegistroOnlineError
    case RegistroRegistradoOnlineError
    
    case SMSOnlineError
    
    // ERRORS FOR OFFLINE
    case CodigoOfflineError
    case SkinOfflineError
    case UsuarioOfflineError
    case PlantillasOfflineError
    case VariablesOfflineError
    
    
    // General errors
    case CodigoError
    case LoginError
    case SkinError
    
    case XMLError
    case ParseError
    case ServerError
    
    // Transited
    case TransitedError
    case NoTransitedOptions
    
    // Retrive Formularios
    case FormsError
    
    case defaultError
    
}
