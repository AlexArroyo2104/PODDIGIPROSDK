//
//  Requests.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 17/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation


public class Requests: NSObject{
    
    public func internetRequest() throws -> URLRequest {
        let theURL = NSURL(string: "https://www.google.com/")
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.httpMethod = "POST"
        return mutableR
    }
    
    public func xmlFolioRequest(mParams mparams: [String], sParams sparams:[String]) -> AEXMLDocument{
        let soapRequest = AEXMLDocument()
        let xmlns = [
            "xmlns:bus" : "http://schemas.datacontract.org/2004/07/BusinessWcfServicios",
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild( name: "soapenv:Envelope", attributes: xmlns )
        let body = envelope.addChild( name: "soapenv:Body" )
        let service = body.addChild( name: "tem:ServicioGenerico" )
        let json = service.addChild( name: "tem:json" )
        json.addChild( name: "bus:id", value: "1" )
        let pin = json.addChild( name: "bus:pin" )
        let method = pin.addChild( name: "bus:method" )
        let methodJson = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson.addChild( name: "bus:datatype", value: "string" )
        methodJson.addChild( name: "bus:order", value: "5" )
        methodJson.addChild( name: "bus:value", value: mparams[0] )
        let system = pin.addChild( name: "bus:system" )
        let systemJson1 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson1.addChild( name: "bus:datatype", value: "int" )
        systemJson1.addChild( name: "bus:order", value: "1" )
        systemJson1.addChild( name: "bus:value", value: sparams[0] ) // ProyectID
        let systemJson2 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson2.addChild( name: "bus:datatype", value: "int" )
        systemJson2.addChild( name: "bus:order", value: "2" )
        systemJson2.addChild( name: "bus:value", value: sparams[1] ) // ExpID
        let systemJson3 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson3.addChild( name: "bus:datatype", value: "int" )
        systemJson3.addChild( name: "bus:order", value: "3" )
        systemJson3.addChild( name: "bus:value", value: sparams[2] ) // Grupo ID USer
        let systemJson4 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson4.addChild( name: "bus:datatype", value: "string" )
        systemJson4.addChild( name: "bus:order", value: "4" )
        systemJson4.addChild( name: "bus:value", value: sparams[3] ) // Login User
        let pout = json.addChild( name: "bus:pout" )
        let poutJson = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson.addChild( name: "bus:datatype", value: "string" )
        poutJson.addChild( name: "bus:order", value: "1" )
        service.addChild( name: "tem:proyid", value: "2" )
        json.addChild( name: "bus:response" )
        return soapRequest
    }
    
    
    public func xmlRegistroRequest(mParams mparams: [String], sParams sparams:[String]) -> AEXMLDocument{
        let soapRequest = AEXMLDocument()
        let xmlns = [
            "xmlns:bus" : "http://schemas.datacontract.org/2004/07/BusinessWcfServicios",
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild( name: "soapenv:Envelope", attributes: xmlns )
        let body = envelope.addChild( name: "soapenv:Body" )
        let service = body.addChild( name: "tem:ServicioGenerico" )
        let json = service.addChild( name: "tem:json" )
        json.addChild( name: "bus:id", value: "2" )
        let pin = json.addChild( name: "bus:pin" )
        let method = pin.addChild( name: "bus:method" )
        let methodJson1 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson1.addChild( name: "bus:datatype", value: "string" )
        methodJson1.addChild( name: "bus:order", value: "1" )
        methodJson1.addChild( name: "bus:value", value: mparams[0] ) // USUARIO
        let methodJson2 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson2.addChild( name: "bus:datatype", value: "string" )
        methodJson2.addChild( name: "bus:order", value: "2" )
        methodJson2.addChild( name: "bus:value", value: mparams[1] )  // PASSWORD
        let methodJson3 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson3.addChild( name: "bus:datatype", value: "string" )
        methodJson3.addChild( name: "bus:order", value: "3" )
        methodJson3.addChild( name: "bus:value", value: mparams[2] )  // NOMBRE
        let methodJson4 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson4.addChild( name: "bus:datatype", value: "string" )
        methodJson4.addChild( name: "bus:order", value: "4" )
        methodJson4.addChild( name: "bus:value", value: mparams[3] )  // APELLIDO PATERNO
        let methodJson5 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson5.addChild( name: "bus:datatype", value: "string" )
        methodJson5.addChild( name: "bus:order", value: "5" )
        methodJson5.addChild( name: "bus:value", value: mparams[4] )  // APELLIDO MATERNO
        let methodJson6 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson6.addChild( name: "bus:datatype", value: "string" )
        methodJson6.addChild( name: "bus:order", value: "6" )
        methodJson6.addChild( name: "bus:value", value: mparams[5] )  // CORREO ELECTRONICO
        let methodJson7 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson7.addChild( name: "bus:datatype", value: "string" )
        methodJson7.addChild( name: "bus:order", value: "7" )
        methodJson7.addChild( name: "bus:value", value: mparams[6] )  // GRUPO
        let methodJson8 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson8.addChild( name: "bus:datatype", value: "int" )
        methodJson8.addChild( name: "bus:order", value: "8" )
        methodJson8.addChild( name: "bus:value", value: mparams[7] )  // PERFILES
        let system = pin.addChild( name: "bus:system" )
        let systemJson1 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson1.addChild( name: "bus:datatype", value: "int" )
        systemJson1.addChild( name: "bus:order", value: "9" )
        systemJson1.addChild( name: "bus:value", value: sparams[0] ) // ProyectID
        let pout = json.addChild( name: "bus:pout" )
        let poutJson = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson.addChild( name: "bus:datatype", value: "int" )
        poutJson.addChild( name: "bus:order", value: "1" )
        service.addChild( name: "tem:proyid", value: "2" )
        json.addChild( name: "bus:response" )
        return soapRequest
    }
    
    
    public func xmlEnvioSMSRequest(mParams mparams: [String], sParams sparams:[String]) -> AEXMLDocument{
        let soapRequest = AEXMLDocument()
        let xmlns = [
            "xmlns:bus" : "http://schemas.datacontract.org/2004/07/BusinessWcfServicios",
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild( name: "soapenv:Envelope", attributes: xmlns )
        let body = envelope.addChild( name: "soapenv:Body" )
        let service = body.addChild( name: "tem:ServicioGenerico" )
        let json = service.addChild( name: "tem:json" )
        json.addChild( name: "bus:id", value: "3" )
        let pin = json.addChild( name: "bus:pin" )
        let method = pin.addChild( name: "bus:method" )
        let methodJson1 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson1.addChild( name: "bus:datatype", value: "string" )
        methodJson1.addChild( name: "bus:order", value: "3" )
        methodJson1.addChild( name: "bus:value", value: mparams[0] )
        let methodJson2 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson2.addChild( name: "bus:datatype", value: "int" )
        methodJson2.addChild( name: "bus:order", value: "4" )
        methodJson2.addChild( name: "bus:value", value: mparams[1] )
        let system = pin.addChild( name: "bus:system" )
        let systemJson1 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson1.addChild( name: "bus:datatype", value: "int" )
        systemJson1.addChild( name: "bus:order", value: "1" )
        systemJson1.addChild( name: "bus:value", value: sparams[0] ) // ProyectID
        let systemJson2 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson2.addChild( name: "bus:datatype", value: "string" )
        systemJson2.addChild( name: "bus:order", value: "2" )
        systemJson2.addChild( name: "bus:value", value: sparams[1] ) // USER
        let pout = json.addChild( name: "bus:pout" )
        let poutJson = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson.addChild( name: "bus:datatype", value: "string" )
        poutJson.addChild( name: "bus:order", value: "1" )
        service.addChild( name: "tem:proyid", value: "2" )
        json.addChild( name: "bus:response" )
        return soapRequest
    }
    
    
    public func xmlValidarSMSRequest(mParams mparams: [String], sParams sparams:[String]) -> AEXMLDocument{
        let soapRequest = AEXMLDocument()
        let xmlns = [
            "xmlns:bus" : "http://schemas.datacontract.org/2004/07/BusinessWcfServicios",
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild( name: "soapenv:Envelope", attributes: xmlns )
        let body = envelope.addChild( name: "soapenv:Body" )
        let service = body.addChild( name: "tem:ServicioGenerico" )
        let json = service.addChild( name: "tem:json" )
        json.addChild( name: "bus:id", value: "4" )
        let pin = json.addChild( name: "bus:pin" )
        let method = pin.addChild( name: "bus:method" )
        let methodJson1 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson1.addChild( name: "bus:datatype", value: "string" )
        methodJson1.addChild( name: "bus:order", value: "3" )
        methodJson1.addChild( name: "bus:value", value: mparams[0] )
        let methodJson2 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson2.addChild( name: "bus:datatype", value: "string" )
        methodJson2.addChild( name: "bus:order", value: "4" )
        methodJson2.addChild( name: "bus:value", value: mparams[1] )
        let system = pin.addChild( name: "bus:system" )
        let systemJson1 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson1.addChild( name: "bus:datatype", value: "int" )
        systemJson1.addChild( name: "bus:order", value: "1" )
        systemJson1.addChild( name: "bus:value", value: sparams[0] ) // ProyectID
        let systemJson2 = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson2.addChild( name: "bus:datatype", value: "string" )
        systemJson2.addChild( name: "bus:order", value: "2" )
        systemJson2.addChild( name: "bus:value", value: sparams[1] ) // USER
        json.addChild( name: "bus:pout" )
        service.addChild( name: "tem:proyid", value: "2" )
        json.addChild( name: "bus:response" )
        return soapRequest
    }
    
    
    
    public func xmlSepomexRequest(mParams mparams: [String], sParams sparams:[String]) -> AEXMLDocument{
        let soapRequest = AEXMLDocument()
        let xmlns = [
            "xmlns:bus" : "http://schemas.datacontract.org/2004/07/BusinessWcfServicios",
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild( name: "soapenv:Envelope", attributes: xmlns )
        let body = envelope.addChild( name: "soapenv:Body" )
        let service = body.addChild( name: "tem:ServicioGenerico" )
        let json = service.addChild( name: "tem:json" )
        json.addChild( name: "bus:id", value: "5" )
        let pin = json.addChild( name: "bus:pin" )
        let method = pin.addChild( name: "bus:method" )
        let methodJson = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson.addChild( name: "bus:datatype", value: "string" )
        methodJson.addChild( name: "bus:order", value: "1" )
        methodJson.addChild( name: "bus:value", value: mparams[0] )
        pin.addChild( name: "bus:system" )
        let pout = json.addChild( name: "bus:pout" )
        let poutJson = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson.addChild( name: "bus:datatype", value: "string" )
        poutJson.addChild( name: "bus:order", value: "1" )
        poutJson.addChild( name: "bus:value", value: sparams[0])
        let poutJson2 = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson2.addChild( name: "bus:datatype", value: "string" )
        poutJson2.addChild( name: "bus:order", value: "2" )
        poutJson2.addChild( name: "bus:value", value: sparams[1])
        let poutJson3 = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson3.addChild( name: "bus:datatype", value: "string" )
        poutJson3.addChild( name: "bus:order", value: "3" )
        poutJson3.addChild( name: "bus:value", value: sparams[2])
        service.addChild( name: "tem:proyid", value: "2" )
        json.addChild( name: "bus:response" )
        return soapRequest
    }
    
    public func xmlActivacionCorreoRequest(mParams mparams: [String], sParams sparams:[String]) -> AEXMLDocument{
        let soapRequest = AEXMLDocument()
        let xmlns = [
            "xmlns:bus" : "http://schemas.datacontract.org/2004/07/BusinessWcfServicios",
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild( name: "soapenv:Envelope", attributes: xmlns )
        let body = envelope.addChild( name: "soapenv:Body" )
        let service = body.addChild( name: "tem:ServicioGenerico" )
        let json = service.addChild( name: "tem:json" )
        json.addChild( name: "bus:id", value: "6" )
        let pin = json.addChild( name: "bus:pin" )
        let method = pin.addChild( name: "bus:method" )
        let methodJson1 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson1.addChild( name: "bus:datatype", value: "string" )
        methodJson1.addChild( name: "bus:order", value: "1" )
        methodJson1.addChild( name: "bus:value", value: mparams[0] )
        let methodJson2 = method.addChild( name: "bus:JsonParameterGenerico" )
        methodJson2.addChild( name: "bus:datatype", value: "string" )
        methodJson2.addChild( name: "bus:order", value: "2" )
        methodJson2.addChild( name: "bus:value", value: mparams[1] )
        let system = pin.addChild( name: "bus:system" )
        let systemJson = system.addChild( name: "bus:JsonParameterGenerico" )
        systemJson.addChild( name: "bus:datatype", value: "int" )
        systemJson.addChild( name: "bus:order", value: "3" )
        systemJson.addChild( name: "bus:value", value: sparams[0] ) // ProyectID
        let pout = json.addChild( name: "bus:pout" )
        let poutJson = pout.addChild( name: "bus:JsonParameterGenerico" )
        poutJson.addChild( name: "bus:datatype", value: "string" )
        poutJson.addChild( name: "bus:order", value: "1" )
        service.addChild( name: "tem:proyid", value: "2" )
        json.addChild( name: "bus:response" )
        return soapRequest
    }
    
    public func codigoRequest() throws -> URLRequest {
        let soapRequest = AEXMLDocument()
        let json = JSONSerializer.toJson(ConfigurationManager.shared.codigoUIAppDelegate)
        let xmlns = [
            "xmlns:SOAP-ENV" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:ns1" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "SOAP-ENV:Envelope",
            attributes: xmlns
        )
        let body = envelope.addChild(
            name: "SOAP-ENV:Body"
        )
        let check = body.addChild(
            name: "ns1:CheckCodigo"
        )
        check.addChild(
            name: "ns1:code",
            value: json
        )
        let soapLenth = String(soapRequest.xml.count)
        let theURL = NSURL(string: httpConnection.access.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            "http://tempuri.org/IWcfCodigo/CheckCodigo",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        
        mutableR.httpMethod = httpMethod.POST.rawValue
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
    }
    
    public func skinRequest() throws -> URLRequest{
        
        let skinObject = FESkin()
        skinObject.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
        skinObject.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
        let jsonObject = JSONSerializer.toJson(skinObject)
        
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ObtieneSkin"
        )
        check.addChild(
            name: "tem:skin",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ObtieneSkin",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = httpMethod.POST.rawValue
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
    }
    
    public func usuarioRequest() throws -> URLRequest{
        
        let jsonObject = JSONSerializer.toJson(ConfigurationManager.shared.usuarioUIAppDelegate)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:Login"
        )
        check.addChild(
            name: "tem:usuario",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/Login",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func registroRequest() throws -> URLRequest{

        let jsonObject = JSONSerializer.toJson(ConfigurationManager.shared.registroUIAppDelegate)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:Registro"
        )
        check.addChild(
            name: "tem:registro",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/Registro",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func activarRegistroRequest() throws -> URLRequest{
        
        let jsonObject = JSONSerializer.toJson(ConfigurationManager.shared.registroUIAppDelegate)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ActivarRegistro"
        )
        check.addChild(
            name: "tem:registro",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ActivarRegistro",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func cambiarContraseniaRequest() throws -> URLRequest{
        
        let jsonObject = JSONSerializer.toJson(ConfigurationManager.shared.usuarioUIAppDelegate)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:CambiarPassword"
        )
        check.addChild(
            name: "tem:usuario",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/CambiarPassword",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func plantillasRequest() throws -> URLRequest{
        
        let jsonObject = JSONSerializer.toJson(ConfigurationManager.shared.plantillaUIAppDelegate)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ObtienePlantillas"
        )
        check.addChild(
            name: "tem:plantilla",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ObtienePlantillas",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func variablesRequest() throws -> URLRequest{
        
        let jsonObject = JSONSerializer.toJson(ConfigurationManager.shared.variablesUIAppDelegate)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ObtieneVariables"
        )
        check.addChild(
            name: "tem:variable",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ObtieneVariables",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func formatosRequest(formato: FEConsultaFormato) throws -> URLRequest{
        
        let jsonObject = JSONSerializer.toJson(formato)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ConsultaFormatos"
        )
        check.addChild(
            name: "tem:formato",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        print("URLREQUEST: \(url)")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ConsultaFormatos",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func deleteFormatoRequest(formato: FEConsultaFormato) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(formato)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:BorraFormatoBorrador"
        )
        check.addChild(
            name: "tem:formato",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/BorraFormatoBorrador",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func sendFormatosRequest(formato: FEConsultaFormato) throws -> URLRequest{
        formato.Formato.JsonDatos = formato.Formato.JsonDatos.replacingOccurrences(of: "\\\"", with: "\\\\\"")
        formato.Formato.JsonDatos = formato.Formato.JsonDatos.replacingOccurrences(of: "\"", with: "\\\"")
        let json = JSONSerializer.toJson(formato)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.customBorrador)/bor.bor", withContent: json as NSObject, overwrite: true)
        let gettingXml = FCFileManager.readFileAtPath(asData: "\(Cnstnt.Tree.customBorrador)/bor.bor")
        let compressedData: Data = try! gettingXml!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:EnviaFormato"
        )
        check.addChild(
            name: "tem:formato",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/EnviaFormato",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func sendAnexosRequest(consulta: FEConsultaAnexo) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(consulta)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:EnviaAnexo"
        )
        check.addChild(
            name: "tem:anexo",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/EnviaAnexo",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func consultaAnexosRequest(consulta: FEConsultaAnexo) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(consulta)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ConsultaAnexo"
        )
        check.addChild(
            name: "tem:anexo",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ConsultaAnexo",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func transitaRequest(formato: FEConsultaFormato) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(formato)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:TransitaFormato"
        )
        check.addChild(
            name: "tem:formato",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/TransitaFormato",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func consultaRequest(consulta: FEConsultaTemplate) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(consulta)
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ConsultaTemplate"
        )
        check.addChild(
            name: "tem:template",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/ConsultaTemplate",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    // TODO: -
    // MARK: - NEW SERVICIOS
    
    public func soapNewFolioRequest(mParams mparams: [String], sParams sparams:[String]) throws -> URLRequest{
        
        let soapRequest = xmlFolioRequest(mParams: mparams, sParams: sparams)
        let soapLenth = String(soapRequest.xml.count)
        //let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfServicios.replacingOccurrences(of: " ", with: "")
        let url = "http://52.167.225.74/Movil/WCFServicios/WCFServicios.svc"
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ServicioGenerico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
        
    }
    
    public func soapNewSMSRequest(mParams mparams: [String], sParams sparams:[String]) throws -> URLRequest{
        
        let soapRequest = xmlEnvioSMSRequest(mParams: mparams, sParams: sparams)
        let soapLenth = String(soapRequest.xml.count)
        
        
        let url = "http://52.167.225.74/Movil/WCFServicios/WCFServicios.svc"
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ServicioGenerico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
        
    }
    
    public func soapNewValidateSMSRequest(mParams mparams: [String], sParams sparams:[String]) throws -> URLRequest{
        
        let soapRequest = xmlValidarSMSRequest(mParams: mparams, sParams: sparams)
        let soapLenth = String(soapRequest.xml.count)
        
        
        let url = "http://52.167.225.74/Movil/WCFServicios/WCFServicios.svc"
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ServicioGenerico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
        
    }
    
    public func soapNewSepomexRequest(mParams mparams: [String], sParams sparams:[String]) throws -> URLRequest{
        
        let soapRequest = xmlSepomexRequest(mParams: mparams, sParams: sparams)
        let soapLenth = String(soapRequest.xml.count)
        
        
        let url = "http://52.167.225.74/Movil/WCFServicios/WCFServicios.svc"
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ServicioGenerico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
        
    }
    
    public func soapNewRegistroRequest(mParams mparams: [String], sParams sparams:[String]) throws -> URLRequest{
        
        let soapRequest = xmlRegistroRequest(mParams: mparams, sParams: sparams)
        let soapLenth = String(soapRequest.xml.count)
        
        
        let url = "http://52.167.225.74/Movil/WCFServicios/WCFServicios.svc"
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ServicioGenerico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
        
    }
    
    public func soapNewActivacionCorreoRequest(mParams mparams: [String], sParams sparams:[String]) throws -> URLRequest{
        
        let soapRequest = xmlActivacionCorreoRequest(mParams: mparams, sParams: sparams)
        let soapLenth = String(soapRequest.xml.count)
        
        
        let url = "http://52.167.225.74/Movil/WCFServicios/WCFServicios.svc"
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ServicioGenerico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
        
    }
    
    // TODO: -
    // MARK: - SERVICIOS
    
    public func compareFacesRequest(compareFaces: CompareFacesResult) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(compareFaces)
        //let dataJson = jsonObject.data(using: .utf8)
        //let compressedData: Data = try! dataJson!.gzipped()
        //let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:CompareFaces"
        )
        check.addChild(
            name: "tem:subject",
            value: jsonObject
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfServicios.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/CompareFaces",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func soapFolioRequest(folio: FolioAutomaticoResult) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(folio)
        //let dataJson = jsonObject.data(using: .utf8)
        //let compressedData: Data = try! dataJson!.gzipped()
        //let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:FolioAutomatico"
        )
        check.addChild(
            name: "tem:folio",
            value: jsonObject
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfServicios.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/FolioAutomatico",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func soapSMSRequest(sms: SmsServicio) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(sms)
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:SendSms"
        )
        check.addChild(
            name: "tem:sms",
            value: jsonObject
        )
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfServicios.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/SendSms",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        
        return mutableR
    }
    
    public func soapValidateSMSRequest(sms: SmsServicio) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(sms)
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:ValidateSmsCode"
        )
        check.addChild(
            name: "tem:sms",
            value: jsonObject
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfServicios.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/ValidateSmsCode",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func soapCorreoRequest(correo: CorreoServicio) throws -> URLRequest{
        let jsonObject = JSONSerializer.toJson(correo)
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:SendMail"
        )
        check.addChild(
            name: "tem:correo",
            value: jsonObject
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfServicios.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IWCFServicios/SendMail",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    // MARK: TESTING
    // MARK: LOGALTY SEND FORMATOS
    public func sendFormatosRequestLogalty(formato: FEConsultaFormato) throws -> URLRequest{
        let formatoJson = formato
        formatoJson.Formato.JsonDatos = formatoJson.Formato.JsonDatos.replacingOccurrences(of: "\"", with: "|")
        let json = JSONSerializer.toJson(formatoJson)
        let jsonObject = json.replacingOccurrences(of: "|", with: "\\\"")
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:GeneraPeticionLogalty"
        )
        check.addChild(
            name: "tem:accept",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/GeneraPeticionLogalty",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func generateSAML(_ json: String) throws -> URLRequest{
        let dataJson = json.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:GeneraSaml"
        )
        check.addChild(
            name: "tem:saml",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/GeneraSaml",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
    
    public func sendFormatosRequestEndLogalty(formato: FELogaltySaml) throws -> URLRequest{
        let formatoJson = formato
        let json = JSONSerializer.toJson(formatoJson)
        let jsonObject = json
        let dataJson = jsonObject.data(using: .utf8)
        let compressedData: Data = try! dataJson!.gzipped()
        let jsonZipB64 =  compressedData.base64EncodedString()
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = [
            "xmlns:soapenv" : "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem" : "http://tempuri.org/"
        ]
        let envelope = soapRequest.addChild(
            name: "soapenv:Envelope",
            attributes: envelopeAttributes
        )
        let body = envelope.addChild(
            name: "soapenv:Body"
        )
        let check = body.addChild(
            name: "tem:TerminaProcesoLogalty"
        )
        check.addChild(
            name: "tem:finish",
            value: jsonZipB64
        )
        
        let soapLenth = String(soapRequest.xml.count)
        let url = ConfigurationManager.shared.codigoUIAppDelegate.WcfFileTransfer.replacingOccurrences(of: " ", with: "")
        let theURL = NSURL(string: url)
        //let theURL = NSURL(string: httpConnection.debug.rawValue)
        var mutableR = URLRequest(url: theURL! as URL)
        mutableR.timeoutInterval = 120
        mutableR.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableR.addValue(
            "text/xml; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        mutableR.addValue(
            soapLenth,
            forHTTPHeaderField: "Content-Length"
        )
        mutableR.addValue(
            "http://tempuri.org/IApp/TerminaProcesoLogalty",
            forHTTPHeaderField: "SOAPAction"
        )
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        return mutableR
    }
}
