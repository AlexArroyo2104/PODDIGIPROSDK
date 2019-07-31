//
//  TextoAreaCell.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 14/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation


public class TextoAreaCell: Cell<String>, CellType, UITextViewDelegate {
    
    // MARK: - IBOUTLETS AND VARS
    @IBOutlet public weak var lblTitle: UILabel!
    @IBOutlet public weak var lblSubtitle: UILabel!
    @IBOutlet public weak var lblRequired: UILabel!
    @IBOutlet public weak var txtInput: UITextView!
    @IBOutlet public weak var lblError: UILabel!
    @IBOutlet public weak var viewValidation: UIView!
    @IBOutlet public weak var bgHabilitado: UIView!
    @IBOutlet public weak var lblMessage: UILabel!
    @IBOutlet public weak var btnInfo: UIButton!
    
    public var formDelegate: FormularioDelegate?
    
    public var genericRow: TextoAreaRow!{return row as? TextoAreaRow}
    public var elemento = Elemento()
    public var atributos: Atributos_textarea!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var mascara: String?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        
        elemento = obj
        atributos = obj.atributos as? Atributos_textarea
        if (atributos?.valor.isEmpty)!{
            self.mascara = atributos?.mascara
            txtInput.text = atributos?.mascara
            txtInput.textColor = UIColor.lightGray
        }else{
            txtInput.text = atributos?.valor
            txtInput.textColor = UIColor.black
        }
        lblTitle.text = atributos?.titulo
        lblSubtitle.text = atributos?.subtitulo
        
        setMinMax()
        setExpresionRegular()
        setOcultarTitulo(atributos!.ocultartitulo)
        setOcultarSubtitulo(atributos!.ocultarsubtitulo)
        setRequerido(atributos!.requerido)
        setVisible(atributos!.visible)
        setHabilitado(atributos!.habilitado)
        
        if atributos?.valor != "" && atributos?.valor != " "{
            textViewDidChange(txtInput)
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
        if row.value == nil{
            txtInput.text = ""
            self.updateIfIsValid()
        }
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
        
        let apiObject = ObjectFormManager<TextoAreaCell>()
        apiObject.delegate = self
        
        height = {return 100}
        btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)

        txtInput.delegate = self
        txtInput.keyboardType = .default
        txtInput.autocorrectionType = .default
        txtInput.autocapitalizationType = .sentences
        txtInput.inputAssistantItem.leadingBarButtonGroups.removeAll()
        txtInput.inputAssistantItem.trailingBarButtonGroups.removeAll()
        txtInput.keyboardAppearance = UIKeyboardAppearance.dark
        txtInput.layer.borderColor = UIColor.lightGray.cgColor
        txtInput.layer.borderWidth = 1.0
        txtInput.layer.cornerRadius = 5.0
        
        lblMessage.layer.cornerRadius = 2.0
        lblError.layer.cornerRadius = 2.0
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
                est!.Campo = "Area Texto"
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
    
    // MARK: TEXTFIELDDELEGATE
    
    
    // MARK: - PROTOCOLS FUNCTIONS
    open override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && txtInput.canBecomeFirstResponder == true
    }
    
    open override func cellBecomeFirstResponder(withDirection: Direction) -> Bool {
        return txtInput.becomeFirstResponder()
    }
    
    open override func cellResignFirstResponder() -> Bool {
        return txtInput.resignFirstResponder()
    }
    
    // MARK: TextViewDelegate
    open func textViewDidBeginEditing(_ textView: UITextView) {
        formViewController()?.beginEditing(of: self)
        formViewController()?.textInputDidBeginEditing(textView, cell: self)
        row.value = textView.text
        setEstadistica()
        if textView.textColor == UIColor.lightGray{
            txtInput.text = nil
            txtInput.textColor = UIColor.black
        }
    }
    open func textViewDidEndEditing(_ textView: UITextView) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textView, cell: self)
        if textView.text.isEmpty{
            txtInput.text = self.mascara
            txtInput.textColor = UIColor.lightGray
        }
        textViewDidChange(textView)
        row.value = textView.text
        triggerEvent("alcambiar")
    }
    
    open func textViewShouldReturn(_ textView: UITextField) -> Bool {
        return formViewController()?.textInputShouldReturn(textView, cell: self) ?? true
    }
    
    open func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return formViewController()?.textInput(textView, shouldChangeCharactersInRange:range, replacementString:string, cell: self) ?? true
    }
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return formViewController()?.textInputShouldBeginEditing(textView, cell: self) ?? true
    }
    
    open func textViewShouldClear(_ textView: UITextView) -> Bool {
        return formViewController()?.textInputShouldClear(textView, cell: self) ?? true
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return formViewController()?.textInputShouldEndEditing(textView, cell: self) ?? true
    }
    
    @objc open func textViewDidChange(_ textView: UITextView) {
        self.setMinMax()
        guard let _ = textView.text, textView.text != "" else {
            row.value = nil
            return
        }
        if (textView.text?.count)! > (atributos?.longitudmaxima)!{
            textView.text = row.value
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.updateIfIsValid()
            }
            return
        }
        switch atributos?.mayusculasminusculas {
        case "normal":
            break
        case "upper":
            textView.text = textView.text?.uppercased()
            break
        case "lower":
            textView.text = textView.text?.lowercased()
            break
        default:
            break
        }
        row.value = textView.text
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.updateIfIsValid()
        }
    }
    
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
                //toolTip?.show(forView: self.btnInfo)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.genericRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }
    }
    
}

// MARK: - OBJECTFORMDELEGATE
extension TextoAreaCell: ObjectFormDelegate{
    
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
                        self.lblSubtitle.isHidden = false
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
                        self.lblSubtitle.isHidden = false
                        self.lblError.text = ""
                        self.lblError.isHidden = true
                        self.viewValidation.backgroundColor = UIColor.green
                        self.layoutIfNeeded()
                }
                if atributos != nil{
                    self.elemento.validacion.needsValidation = atributos.requerido
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
                self.lblSubtitle.isHidden = true
                self.viewValidation.backgroundColor = UIColor.red
                if (self.row.validationErrors.count) > 0{
                    self.lblError.text = self.row.validationErrors[0].msg
                }
                self.lblError.isHidden = false
                self.layoutIfNeeded()
            }
            self.elemento.validacion.needsValidation = true
            self.elemento.validacion.validado = false
            self.elemento.validacion.valor = ""
            self.elemento.validacion.valormetadato = ""
        }
    }
    
    public func setMinMax(){
        var rules = RuleSet<String>()
        if atributos != nil{
            if atributos!.longitudminima != 0{
                rules.add(rule: ReglaMinLongitud(minLength: UInt(atributos!.longitudminima)))
            }
            if atributos!.longitudmaxima != 0{
                rules.add(rule: ReglaMaxLongitud(maxLength: UInt(atributos!.longitudmaxima)))
            }
        }
        row.add(ruleSet: rules)
    }
    public func setExpresionRegular(){
        var rules = RuleSet<String>()
        if atributos!.expresionregular != ""{
            
            if atributos!.expresionregular == "*" || atributos!.expresionregular == "." || atributos!.expresionregular == ".*"  || atributos!.expresionregular == "*." || atributos!.expresionregular == "\\w"{
                atributos!.expresionregular = ".*+"
            }
            
            if atributos!.regexrerrormsg != ""{
                
                if (atributos?.requerido)!{
                    rules.add(rule: ReglaExpReg(regExpr: atributos!.expresionregular, allowsEmpty: false, msg: "\(atributos!.regexrerrormsg)", id: nil))
                }else{
                    rules.add(rule: ReglaExpReg(regExpr: atributos!.expresionregular, allowsEmpty: true, msg: "\(atributos!.regexrerrormsg)", id: nil))
                }
                
            }else{
                
                if (atributos?.requerido)!{
                    rules.add(rule: ReglaExpReg(regExpr: atributos!.expresionregular, allowsEmpty: false, msg: "El campo no cumple la siguiente expresión: \(atributos!.expresionregular)", id: nil))
                }else{
                    rules.add(rule: ReglaExpReg(regExpr: atributos!.expresionregular, allowsEmpty: true, msg: "El campo no cumple la siguiente expresión: \(atributos!.expresionregular)", id: nil))
                }
                
            }
            
        }
        row.add(ruleSet: rules)
    }
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
        txtInput.text = v
        row.value = v
        
        setEstadistica()
        // MARK: - Estadística
        est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
        est!.Resultado = v
        est!.KeyStroke += 1
        elemento.estadisticas = est!
        
        textViewDidChange(txtInput)
        triggerEvent("alentrar")
    }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
                if bool{
                    self.row.hidden = false
                    self.height = {return 100}
                    self.atributos?.visible = true
                }else{
                    self.row.hidden = true
                    self.height = {return 0}
                    self.atributos?.visible = false
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
        // alentrar
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
        }
    }
    
}
