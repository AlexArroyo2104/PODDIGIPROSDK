//
//  TextoCell
//
//  Created by Jonathan Viloria M on 20/07/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class TextoCell: Cell<String>, CellType, UITextFieldDelegate {
    
    // MARK: - IBOUTLETS AND VARS
    @IBOutlet public weak var lblTitle: UILabel!
    @IBOutlet public weak var lblSubtitle: UILabel!
    @IBOutlet public weak var lblRequired: UILabel!
    @IBOutlet public weak var txtInput: UITextField!
    @IBOutlet public weak var lblError: UILabel!
    @IBOutlet public weak var viewValidation: UIView!
    @IBOutlet public weak var bgHabilitado: UIView!
    @IBOutlet public weak var lblMessage: UILabel!
    @IBOutlet public weak var btnInfo: UIButton!
    
    public var formDelegate: FormularioDelegate?
    
    public var genericRow: TextoRow! {return row as? TextoRow}
    public var elemento = Elemento()
    public var atributos: Atributos_texto!
    public var atributosPassword: Atributos_password!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        elemento = obj
        atributos = obj.atributos as? Atributos_texto
        txtInput.text = atributos?.valor
        lblTitle.text = atributos?.titulo
        lblSubtitle.text = atributos?.subtitulo
        txtInput.placeholder = atributos?.mascara
        
        setMinMax()
        setExpresionRegular()
        setOcultarTitulo(atributos!.ocultartitulo)
        setOcultarSubtitulo(atributos!.ocultarsubtitulo)
        setRequerido(atributos!.requerido)
        setVisible(atributos!.visible)
        setHabilitado(atributos!.habilitado)
        
        if atributos?.valor != "" && atributos?.valor != " "{
            textFieldDidChange(txtInput)
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
    
    public func setObjectPassword(obj: Elemento){
        
        elemento = obj
        atributosPassword = obj.atributos as? Atributos_password
        
        txtInput.text = atributosPassword?.valor
        lblTitle.text = atributosPassword?.titulo
        lblSubtitle.text = atributosPassword?.subtitulo
        txtInput.placeholder = atributosPassword?.mascara
        
        setMinMax()
        setExpresionRegular()
        setOcultarTitulo(atributosPassword!.ocultartitulo)
        setOcultarSubtitulo(atributosPassword!.ocultarsubtitulo)
        setRequerido(atributosPassword!.requerido)
        setVisible(atributosPassword!.visible)
        setHabilitado(atributosPassword!.habilitado)
        txtInput.isSecureTextEntry = true
        
        if atributosPassword?.ayuda != nil, atributosPassword?.ayuda != ""{
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
        guard let ayuda = atributosPassword?.ayuda, !ayuda.isEmpty else {
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
        
        let apiObject = ObjectFormManager<TextoCell>()
        apiObject.delegate = self
        
        height = {return 72}

        btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        
        txtInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
                est!.Campo = "Texto"
                est!.NombrePagina = atributos!.elementopadre
                est!.OrdenCampo = atributos!.ordencampo
                let idPag = atributos!.elementopadre.replacingOccurrences(of: "formElec_element", with: "")
                est!.PaginaID = Int(idPag) ?? 0
            }else if atributosPassword != nil{
                est!.Campo = "Password"
                est!.NombrePagina = atributosPassword!.elementopadre
                est!.OrdenCampo = atributosPassword!.ordencampo
                let idPag = atributosPassword!.elementopadre.replacingOccurrences(of: "formElec_element", with: "")
                est!.PaginaID = Int(idPag) ?? 0
            }
            est!.FechaEntrada = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Latitud = ConfigurationManager.shared.latitud
            est!.Longitud = ConfigurationManager.shared.longitud
            est!.Usuario = ConfigurationManager.shared.usuarioUIAppDelegate.User
            est!.Dispositivo = UIDevice().model
            est!.NombrePlantilla = ""
            est!.Sesion = ConfigurationManager.shared.guid
            est!.PlantillaID = 0
            let idElem = elemento._idelemento.replacingOccurrences(of: "formElec_element", with: "")
            est!.CampoID = Int(idElem) ?? 0
            
        }
    }
    
    // MARK: TEXTFIELDDELEGATE
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        formViewController()?.beginEditing(of: self)
        formViewController()?.textInputDidBeginEditing(textField, cell: self)
        row.value = textField.text
        setEstadistica()
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
        textFieldDidChange(textField)
        row.value = textField.text
        triggerEvent("alcambiar")
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldReturn(textField, cell: self) ?? true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return formViewController()?.textInput(textField, shouldChangeCharactersInRange:range, replacementString:string, cell: self) ?? true
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldBeginEditing(textField, cell: self) ?? true
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldClear(textField, cell: self) ?? true
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return formViewController()?.textInputShouldEndEditing(textField, cell: self) ?? true
    }
    
    @objc open func textFieldDidChange(_ textField: UITextField) {

        guard let _ = textField.text else {
            row.value = nil
            self.updateIfIsValid()
            return
        }
        
        if self.atributos != nil{
            if (textField.text?.count)! > (atributos?.longitudmaxima)!{
                textField.text = row.value
                self.updateIfIsValid()
                return
            }
        }
        if self.atributosPassword != nil{
            if (textField.text?.count)! > (atributosPassword?.longitudmaxima)!{
                textField.text = row.value
                self.updateIfIsValid()
                return
            }
        }
        
        if self.atributos != nil{
            switch atributos?.mayusculasminusculas {
            case "normal":
                break
            case "upper":
                textField.text = textField.text?.uppercased()
                break
            case "lower":
                textField.text = textField.text?.lowercased()
                break
            default:
                break
            }
        }
        
        row.value = textField.text
        row.validate()
        self.updateIfIsValid()
    }

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
                else{
                    self.btnInfo.isHidden = true
                }
                toolTip = EasyTipView(text: "\(help)", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.genericRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }else if self.atributosPassword != nil{
            if isInfoToolTipVisible{
                toolTip!.dismiss()
                isInfoToolTipVisible = false
                return
            }else{
                if atributosPassword?.ayuda != "" { help = (atributosPassword?.ayuda)! }
                else{
                    self.btnInfo.isHidden = true
                }
                toolTip = EasyTipView(text: "\(atributosPassword?.ayuda ?? "")", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.genericRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }
    }

}


// MARK: - OBJECTFORMDELEGATE
extension TextoCell: ObjectFormDelegate{
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
                if atributosPassword != nil{
                    self.elemento.validacion.needsValidation = atributosPassword.requerido
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
        if atributosPassword != nil{
            if atributosPassword!.longitudminima != 0{
                rules.add(rule: ReglaMinLongitud(minLength: UInt(atributosPassword!.longitudminima)))
            }
            if atributosPassword!.longitudmaxima != 0{
                rules.add(rule: ReglaMaxLongitud(maxLength: UInt(atributosPassword!.longitudmaxima)))
            }
        }
        row.add(ruleSet: rules)
    }
    public func setExpresionRegular(){
        var rules = RuleSet<String>()
        if atributos != nil{
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
        }
        if atributosPassword != nil{
            if atributosPassword!.expresionregular != ""{
                
                if atributosPassword!.expresionregular == "*"{
                    atributosPassword!.expresionregular = "\\w"
                }
                
                if atributosPassword!.regexrerrormsg != ""{
                    rules.add(rule: ReglaExpReg(regExpr: atributosPassword!.expresionregular, allowsEmpty: false, msg: "\(atributosPassword!.regexrerrormsg)", id: nil))
                }else{
                    rules.add(rule: ReglaExpReg(regExpr: atributosPassword!.expresionregular, allowsEmpty: false, msg: "El campo no cumple la siguiente expresión: \(atributosPassword!.expresionregular)", id: nil))
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
        
        textFieldDidChange(txtInput)
        triggerEvent("alcambiar")
    }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            
                if self.atributos != nil{
                    if bool{
                        self.row.hidden = false
                        self.height = {return 72}
                        self.atributos?.visible = true
                    }else{
                        self.row.hidden = true
                        self.height = {return 0}
                        self.atributos?.visible = false
                    }
                }
                
                if self.atributosPassword != nil{
                    if bool{
                        self.row.hidden = false
                        self.height = {return 72}
                        self.atributosPassword?.visible = true
                    }else{
                        self.row.hidden = true
                        self.height = {return 0}
                        self.atributosPassword?.visible = false
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
        
        if atributosPassword != nil, (atributosPassword?.eventos.count)! > 0{
            for evento in (atributosPassword?.eventos)!{
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
