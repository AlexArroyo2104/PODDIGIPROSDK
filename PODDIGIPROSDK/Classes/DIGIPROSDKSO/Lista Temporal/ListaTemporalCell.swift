//
//  ListaTemporalCell.swift
//  DIGIPROSDKSO
//
//  Created by Alejandro López Arroyo on 6/27/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import Foundation
import UIKit

public class ListaTemporalCell: Cell<String>, CellType {
    
    // MARK: - IBOUTLETS AND VARS
    @IBOutlet public weak var lblTitle: UILabel!
    @IBOutlet public weak var lblSubtitle: UILabel!
    @IBOutlet public weak var lblRequired: UILabel!
    @IBOutlet public weak var lblError: UILabel!
    @IBOutlet public weak var viewValidation: UIView!
    @IBOutlet public weak var bgHabilitado: UIView!
    @IBOutlet public weak var lblMessage: UILabel!
    @IBOutlet public weak var btnInfo: UIButton!
    @IBOutlet public weak var txtCell: UITextView!
    
    public var formDelegate: FormularioDelegate?
    public var genericRow: ListaTemporalRow! {return row as? ListaTemporalRow}
    public var elemento = Elemento()
    public var atributos: Atributos_listatemporal?
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        elemento = obj
        atributos = obj.atributos as? Atributos_listatemporal
        
        lblTitle.text = atributos?.titulo
        //lblSubtitle.text = atributos?.subtitulo
        setOcultarTitulo(atributos!.ocultartitulo)
        //setOcultarSubtitulo(true)
        //setRequerido(atributos!.requerido)
        setVisible(false)
        setHabilitado(false)
        
    }
    
    public func setElements(_ v:String){
        setVisible(true)
        setHabilitado(true)
        let form = Form()
        var listarow: SelectableSection<ListCheckRow<String>>?
        listarow = SelectableSection<ListCheckRow<String>>("", selectionType: .singleSelection(enableDeselection: true))
        
        form +++ listarow!
        
        let listVariables = v.split{$0 == ","}.map(String.init)
        
        for (index, variable) in listVariables.enumerated(){
            
            if index == 0{
                form.last! <<< ListCheckRow<String>("-"){ listPrRow in
                    listPrRow.title = "--Selecione--"
                    listPrRow.selectableValue = "--Selecione--"
                    listPrRow.value = "--Selecione--"
                }
                setEdited(v: "--Selecione--")
            }
            form.last! <<< ListCheckRow<String>("\(variable)"){ listPrRow in
                listPrRow.title = "\(variable)"
                listPrRow.selectableValue = "\(variable)"
                listPrRow.value = nil
                }.onChange({ row in
                    self.setEdited(v: row.tag!)
                    _ = self.formDelegate?.resolveValor(self.atributos!.elementoligado, "asignacion", row.tag!, nil)
                })
            
        }
        let controller = genericRow.presentationMode?.makeController() as! ListaTemporalViewController
        controller.initForm(form)
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
        
        let apiObject = ObjectFormManager<ListaTemporalCell>()
        apiObject.delegate = self
        
        height = {return 80}
        
        //btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        //self.btnInfo.layer.borderWidth = 1.0
        //self.btnInfo.layer.borderColor = UIColor.lightGray.cgColor
        //self.btnInfo.layer.cornerRadius = self.btnInfo.frame.height / 2
        lblMessage.layer.cornerRadius = 2.0
        lblError.layer.cornerRadius = 2.0
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
                est!.Campo = "Lista Temporal"
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
    
    
}



extension ListaTemporalCell: ObjectFormDelegate{
   
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
    
    public func updateIfIsValid(animated: Bool = true){
        self.lblMessage.isHidden = true
        if row.isValid{
            // Setting row as valid
            if row.value == nil{
                DispatchQueue.main.async {
                    
                    self.lblError.text = ""
                    self.lblError.isHidden = true
                    self.viewValidation.backgroundColor = UIColor.gray
                    self.layoutIfNeeded()
                }
                self.elemento.validacion.validado = false
                self.elemento.validacion.valor = ""
                self.elemento.validacion.valormetadato = ""
            }else{
                DispatchQueue.main.async {
                    self.lblError.text = ""
                    self.lblError.isHidden = true
                    self.viewValidation.backgroundColor = UIColor.green
                    self.layoutIfNeeded()
                }
                if row.isValid && row.value != "" {
                    self.elemento.validacion.validado = true
                    self.elemento.validacion.valor = row.value ?? ""
                    self.elemento.validacion.valormetadato  = row.value ?? ""
                }else{
                    self.elemento.validacion.validado = false
                    self.elemento.validacion.valor = ""
                    self.elemento.validacion.valormetadato = ""
                }
            }
        }else{
            // Throw the first error printed in the label
            DispatchQueue.main.async {
                
                self.viewValidation.backgroundColor = UIColor.red
                if (self.row.validationErrors.count) > 0{
                    self.lblError.text = self.row.validationErrors[0].msg
                }
                self.lblError.isHidden = false
                self.layoutIfNeeded()
            }
            self.elemento.validacion.validado = false
            self.elemento.validacion.valor = ""
            self.elemento.validacion.valormetadato = ""
        }
    }
    public func setMinMax(){ }
    public func setExpresionRegular(){ }
    public func setOcultarTitulo(_ bool: Bool){
        DispatchQueue.main.async {
            if bool{
                self.lblTitle.isHidden = true
            }else{
                self.lblTitle.isHidden = false
            }
            self.layoutIfNeeded()
        }
    }
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
        txtCell.text = v
        row.value = v
        
        setEstadistica()
        // MARK: - Estadística
        est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
        est!.Resultado = v.replacingOccurrences(of: "\r\n", with: "|")
        est!.KeyStroke += 1
        elemento.estadisticas = est!
        
        triggerEvent("alcambiar")
        self.updateIfIsValid()
    }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            
            if self.atributos != nil{
                if bool{
                    self.row.hidden = false
                    self.height = {return 80}
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
    public func setRequerido(_ bool: Bool){
        self.elemento.validacion.needsValidation = bool
        DispatchQueue.main.async {
            var rules = RuleSet<String>()
            if bool{
                rules.add(rule: ReglaRequerido())
                self.lblRequired.isHidden = false
            }else{
                self.lblRequired.isHidden = true
            }
            self.layoutIfNeeded()
            self.row.add(ruleSet: rules)
        }
    }
    
    public func triggerEvent(_ action: String) {
       /* // alentrar
        // alcambiar
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
        }*/
        
    }
    
    
}
