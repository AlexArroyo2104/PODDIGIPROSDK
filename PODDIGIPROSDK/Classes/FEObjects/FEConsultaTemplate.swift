//
//  FEConsultaTemplate.swift
//  DGFmwrk
//
//  Created by Jonathan Viloria M on 1/29/19.
//  Copyright © 2019 Digipro Movil. All rights reserved.
//

import Foundation

public class FEConsultaTemplate: EVObject{
    
    public var User = "";
    public var Password = "";
    public var IP = "";
    public var ProyectoID = 0;
    public var AplicacionID = 0;
    public var GrupoAdminID = 0;
    public var LastID = "";
    public var NumberToGo = 0;
    public var Consulta = FETipoReporte();
    public var TotalRegistros = 0;
    public var RegistrosPorPagina = 10;
    public var JsonConsulta = "";
    public var Filtro = ""
    
}
