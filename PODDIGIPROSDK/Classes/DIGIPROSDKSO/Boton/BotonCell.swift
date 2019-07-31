//
//  BotonCell.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 24/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation


public class BotonCell: Cell<String>, CellType {
    
    @IBOutlet public weak var boton: UIButton!
    @IBOutlet public weak var lblSubtitle: UILabel!
    @IBOutlet public weak var lblError: UILabel!
    @IBOutlet public weak var bgHabilitado: UIView!
    @IBOutlet public weak var lblMessage: UILabel!
    @IBOutlet public weak var btnInfo: UIButton!
    
    public var formDelegate: FormularioDelegate?
    
    public var genericRow: BotonRow! {return row as? BotonRow}
    public var elemento = Elemento()
    public var atributos: Atributos_boton!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        elemento = obj
        atributos = obj.atributos as? Atributos_boton
        boton.setTitle(atributos!.valor, for: .normal)
        setVisible(atributos!.visible)
        setHabilitado(atributos!.habilitado)
        setColors()
        
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
        
        let apiObject = ObjectFormManager<BotonCell>()
        apiObject.delegate = self
        
        height = {return 70}
        
        btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        boton.addTarget(self, action: #selector(botonAction(_:)), for: .touchDown)
        
        boton.clipsToBounds = true
        lblMessage.layer.cornerRadius = 2.0
        lblError.layer.cornerRadius = 2.0
        boton.layer.cornerRadius = 10.0
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
                est!.Campo = "Boton"
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
    
    public func setColors(){
        
        if atributos?.colortexto == "" && atributos?.colorfondo == ""{
            boton.backgroundColor = UIColor(hexFromString: "#3c8dbc")
            boton.setTitleColor(UIColor.white, for: .normal)
            
        }else{
            boton.backgroundColor = UIColor(hexFromString: (atributos?.colorfondo)!)
            boton.setTitleColor(UIColor(hexFromString: (atributos?.colortexto)!), for: .normal)
        }
        
        
    }
    
    @IBAction public func botonAction(_ sender: UIButton?) {
        
        setEstadistica()
        // MARK: - Estadística
        est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
        est!.Resultado = ""
        est!.KeyStroke += 1
        elemento.estadisticas = est!
        
        triggerEvent("aldarclick")
        if atributos?.urllink != ""{
            let alert = UIAlertController(title: "Info", message: "Se ha detectado la siguiente url: \((atributos?.urllink)!), deseas abrir la url en tu navegador?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    if let digiproUrl = URL(string: (self.atributos?.urllink)!) {
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(digiproUrl)) {
                            application.open(digiproUrl, options: [:], completionHandler: nil)
                        }
                    }
                    break
                case .cancel:
                    break
                case .destructive:
                    break
                @unknown default:
                    break
                }}))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    break
                case .cancel:
                    print("cancel")
                    break
                case .destructive:
                    break
                @unknown default:
                    break
                }}))
            self.genericRow.cell.formCell()?.formViewController()?.present(alert, animated: true, completion: nil)
        }
        
    }

}

// MARK: - OBJECTFORMDELEGATE
extension BotonCell: ObjectFormDelegate{
    // Protocolos Genéricos
    public func setVariableHeight(Height h: CGFloat) {}
    public func setMessage(_ string: String, _ state: String){
        self.lblError.isHidden = true
        self.lblSubtitle.isHidden = true
        if isServiceMessageDisplayed == 0{
            isServiceMessageDisplayed += 1
            DispatchQueue.main.async {
                    self.lblMessage.text = string
                    switch state{
                    case "message":
                        self.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    case "valid":
                        self.lblMessage.textColor = UIColor(red: 59/255, green: 198/255, blue: 81/255, alpha: 1.0)
                        break
                    case "alert":
                        self.lblMessage.textColor = UIColor(red: 249/255, green: 154/255, blue: 0/255, alpha: 1.0)
                        break
                    case "error":
                        self.lblMessage.textColor = UIColor(red: 227/255, green: 90/255, blue: 102/255, alpha: 1.0)
                        break
                    default:
                        self.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    }
                    self.lblMessage.isHidden = false
                    self.layoutIfNeeded()
                    
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(isServiceMessageDisplayed * 3), execute: {
                    self.lblMessage.text = string
                    switch state{
                    case "message":
                        self.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    case "valid":
                        self.lblMessage.textColor = UIColor(red: 59/255, green: 198/255, blue: 81/255, alpha: 1.0)
                        break
                    case "alert":
                        self.lblMessage.textColor = UIColor(red: 249/255, green: 154/255, blue: 0/255, alpha: 1.0)
                        break
                    case "error":
                        self.lblMessage.textColor = UIColor(red: 227/255, green: 90/255, blue: 102/255, alpha: 1.0)
                        break
                    default:
                        self.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    }
                    self.lblMessage.isHidden = false
                    self.layoutIfNeeded()
                    self.isServiceMessageDisplayed -= 1
            })
        }
    }
    public func updateIfIsValid(animated: Bool = true){ }
    public func setMinMax(){ }
    public func setExpresionRegular(){ }
    public func setOcultarTitulo(_ bool: Bool){ }
    public func setOcultarSubtitulo(_ bool: Bool){
        DispatchQueue.main.async {
                if bool{
                    self.lblSubtitle.isHidden = true
                }else{
                    self.lblSubtitle.isHidden = false
                }
                self.layoutIfNeeded()
        }
    }
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
    public func setEdited(v: String){
        row.value = v
        
    }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            
                if self.atributos != nil{
                    if bool{
                        self.row.hidden = false
                        self.height = {return 70}
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
    
    public func triggerEvent(_ action: String) {
        // aldarclick
        if atributos != nil, (atributos?.eventos.count)! > 0{
            for evento in (atributos?.eventos)!{
                for expresion in evento.expresion{
                    if expresion._tipoexpression == action{
                        DispatchQueue.main.async {
                            self.formDelegate?.addEventAction(evento)
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.formDelegate?.obtainRules(rString: nil, eString: self.row.tag, vString: "click")
        }
        
    }
    
}
