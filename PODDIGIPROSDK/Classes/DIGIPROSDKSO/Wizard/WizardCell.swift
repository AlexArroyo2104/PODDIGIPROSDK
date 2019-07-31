//
//  WizardCell.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 17/09/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class WizardCell: Cell<String>, CellType {
    
    @IBOutlet public weak var regresarBtn: UIButton!
    @IBOutlet public weak var avanzarBtn: UIButton!
    @IBOutlet public weak var finalizarBtn: UIButton!
    @IBOutlet public weak var bgHabilitado: UIView!
    @IBOutlet public weak var btnInfo: UIButton!
    
    public var formDelegate: FormularioDelegate?
    
    public var genericRow: WizardRow! {return row as? WizardRow}
    public var elemento = Elemento()
    public var atributos: Atributos_wizard!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil

    @IBAction func regresarBtnAction(_ sender: UIButton) {
        formDelegate?.wizardAction(id: (atributos?.paginaregresar)!, validar: (atributos?.validacion)!, tipo: "regresar", atributos: (atributos)!)
        est!.KeyStroke += 1
    }
    @IBAction func avanzarBtnAction(_ sender: UIButton) {
        formDelegate?.wizardAction(id: (atributos?.paginaavanzar)!, validar: (atributos?.validacion)!, tipo: "avanzar", atributos: (atributos)!)
        est!.KeyStroke += 1
    }
    @IBAction func finalizarBtnAction(_ sender: UIButton) {
        formDelegate?.wizardAction(id: (atributos?.tareafinalizar)!, validar: true, tipo: "finalizar", atributos: (atributos)!)
        est!.KeyStroke += 1
    }
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        elemento = obj
        atributos = obj.atributos as? Atributos_wizard
        regresarBtn.setTitle(atributos!.textoregresar, for: .normal)
        avanzarBtn.setTitle(atributos!.textoavanzar, for: .normal)
        finalizarBtn.setTitle(atributos!.textofinalizar, for: .normal)
        
        if !atributos!.visibleavanzar{
            avanzarBtn.isHidden = true
        }
        if !atributos!.visibleregresar{
            regresarBtn.isHidden = true
        }
        if !atributos!.visiblefinalizar{
            finalizarBtn.isHidden = true
        }
        
        setColors()
        setVisible(atributos!.visible)
        setHabilitado(atributos!.habilitado)
        
        setEstadistica()
        
        if (atributos?.ayuda != nil){
            self.btnInfo.isHidden = false }
        else{
            self.btnInfo.isHidden = true
        }
        
        if atributos?.ayuda != nil, atributos?.ayuda != ""{
            self.btnInfo.isHidden = false
        }else{
            self.btnInfo.isHidden = true
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblLeftTitle" {
                    constraint.constant = -20
                    self.layoutIfNeeded()
                }
            }
        }
        guard let ayuda = atributos?.ayuda, !ayuda.isEmpty else {
            self.btnInfo.isHidden = true
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblLeftTitle" {
                    constraint.constant = -20
                    self.layoutIfNeeded()
                }
            }
            return
        }
        
    }
    
    override open func update() {
        super.update()
    }
    
    // MARK: - INIT
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        
        let apiObject = ObjectFormManager<WizardCell>()
        apiObject.delegate = self
        
        self.height = {return 100}
        
        btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        
        regresarBtn.layer.cornerRadius = 10.0
        finalizarBtn.layer.cornerRadius = 10.0
        avanzarBtn.layer.cornerRadius = 10.0
        self.btnInfo.layer.borderWidth = 1.0
        self.btnInfo.layer.borderColor = UIColor.lightGray.cgColor
        self.btnInfo.layer.cornerRadius = self.btnInfo.frame.height / 2
    }
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
        if isInfoToolTipVisible{
            toolTip!.dismiss()
            isInfoToolTipVisible = false
        }
    }
    
    // MARK: - ESTADISTICAS
    open func setEstadistica(){
        if est == nil{
            // MARK: - Estadística
            est = FEEstadistica()
            if atributos != nil{
                est!.Campo = "Wizard"
            }
            est!.FechaEntrada = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Latitud = ConfigurationManager.shared.latitud
            est!.Longitud = ConfigurationManager.shared.longitud
            est!.Usuario = ConfigurationManager.shared.usuarioUIAppDelegate.User
            est!.Dispositivo = UIDevice().model
            est!.NombrePlantilla = ""
            est!.NombrePagina = atributos!.elementopadre
            est!.OrdenCampo = atributos!.ordencampo
            est!.Sesion = ConfigurationManager.shared.guid
            est!.PlantillaID = 0
            let idPag = atributos!.elementopadre.replacingOccurrences(of: "formElec_element", with: "")
            est!.PaginaID = Int(idPag) ?? 0
            let idElem = elemento._idelemento.replacingOccurrences(of: "formElec_element", with: "")
            est!.CampoID = Int(idElem) ?? 0
            est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Resultado = ""
            est!.KeyStroke += 1
            elemento.estadisticas = est!
        }
    }
    
    public func setColors(){
        
        if atributos?.colorfondoregresar == "" && atributos?.colortextoregresar == ""{
            regresarBtn.backgroundColor = UIColor(hexFromString: "#3c8dbc")
            regresarBtn.setTitleColor(UIColor.white, for: .normal)
        }else{
            regresarBtn.backgroundColor = UIColor(hexFromString: atributos!.colorfondoregresar)
            regresarBtn.setTitleColor(UIColor(hexFromString: atributos!.colortextoregresar), for: .normal)
        }
        
        if atributos!.colorfondoregresar == "" && atributos!.colortextoavanzar == ""{
            avanzarBtn.backgroundColor = UIColor(hexFromString:"#3c8dbc")
            avanzarBtn.setTitleColor(UIColor.white, for: .normal)
        }else{
            avanzarBtn.backgroundColor = UIColor(hexFromString: atributos!.colorfondoregresar)
            avanzarBtn.setTitleColor(UIColor(hexFromString: atributos!.colortextoavanzar), for: .normal)
        }
        
        if atributos!.colorfondofinalizar == "" && atributos!.colortextofinalizar == ""{
            finalizarBtn.backgroundColor = UIColor(hexFromString: "#3c8dbc")
            finalizarBtn.setTitleColor(UIColor.white, for: .normal)
        }else{
            finalizarBtn.backgroundColor = UIColor(hexFromString: atributos!.colorfondofinalizar)
            finalizarBtn.setTitleColor(UIColor(hexFromString: atributos!.colortextofinalizar), for: .normal)
        }
        
    }
    
    // Aditional Func Objc
    @objc public func setAyuda(_ sender: Any) {
        
        var help = "No hay ayuda disponible"
        if self.atributos != nil{
            if isInfoToolTipVisible{
                toolTip!.dismiss()
                isInfoToolTipVisible = false
                return
            }else{
                if atributos?.ayuda != "" { help = (atributos?.ayuda)! }
                toolTip = EasyTipView(text: "\(help)", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.genericRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }
    }
    
}

// MARK: - OBJECTFORMDELEGATE
extension WizardCell: ObjectFormDelegate{
    // Protocolos Genéricos
    public func setVariableHeight(Height h: CGFloat) {}
    public func setMessage(_ string: String, _ state: String){ }
    public func updateIfIsValid(animated: Bool = true){ }
    public func setMinMax(){ }
    public func setExpresionRegular(){ }
    public func setOcultarTitulo(_ bool: Bool){ }
    public func setOcultarSubtitulo(_ bool: Bool){ }
    public func setHabilitado(_ bool: Bool){
        self.elemento.validacion.habilitado = bool
        DispatchQueue.main.async {
                if bool{
                    self.bgHabilitado.isHidden = true;
                    self.row.baseCell.isUserInteractionEnabled = true
                    self.row.disabled = false
                    self.row.evaluateDisabled()
                }else{
                    self.bgHabilitado.isHidden = false;
                    self.row.baseCell.isUserInteractionEnabled = false
                    self.row.disabled = true
                    self.row.evaluateDisabled()
                }
                self.layoutIfNeeded()
            self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
        }
    }
    public func setEdited(v: String){ }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            
                if self.atributos != nil{
                    if bool{
                        self.row.hidden = false
                        self.height = {return 100}
                        self.atributos?.visible = true
                    }else{
                        self.row.hidden = true
                        self.height = {return 0}
                        self.atributos?.visible = false
                    }
                }
                
                self.layoutIfNeeded()
            self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
        }
    }
    public func setRequerido(_ bool: Bool){ }
    
    public func triggerEvent(_ action: String) { }
    
}
