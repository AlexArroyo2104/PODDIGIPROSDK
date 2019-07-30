//
//  FEUsuario.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 20/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class FEUsuario: EVObject{
    public var User = "default"
    public var Password = ""
    public var IP = ""
    public var ProyectoID = 0
    public var AplicacionID = 0
    public var NombreCompleto = ""
    public var GrupoAdminID = 0
    public var Foto = ""
    public var PermisoScreenshot = true
    public var PermisoEditarFormato = true
    public var PermisoDescargarAnexos = true
    public var PendientesEstadoMapa = 0
    public var PermisoValidarFormato = true
    public var PermisoVerMapa = true
    public var PermisoBorrarFormato = true
    public var PermisoPendientesPorEnviar = true
    public var PermisoNuevoFormato = true
    public var PermisoSalirConCambios = true
    public var PermisoVisualizarFormato = true
    public var PasswordEncoded = ""
    public var CurrentPasswordEncoded = ""
    public var PasswordNuevo = ""
    public var NewPasswordEncoded = ""

    public var Consultas: Array<FETipoReporte> = [FETipoReporte]()
    
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
