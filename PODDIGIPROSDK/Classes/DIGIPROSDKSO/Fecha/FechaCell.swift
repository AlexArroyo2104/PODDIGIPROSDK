//
//  FechaCell.swift
//  customForm
//
//  Created by Jonathan Viloria M on 15/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

open class FechaCell: Cell<Date>, CellType, UITextFieldDelegate {
    
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
    
    public var fechaRow: FechaRow! {return row as? FechaRow}
    public var horaRow: HoraRow! {return row as? HoraRow}
    public var elemento = Elemento()
    public var atributos: Atributos_fecha!
    public var atributosHora: Atributos_hora!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var datePicker: UIDatePicker
    public var formato = ""
    public let formatter = DateFormatter()
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil
    
    // MARK: SETTING
    public func setObject(obj: Elemento){
        
        elemento = obj
        atributos = obj.atributos as? Atributos_fecha
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
        
        if atributos?.formato != ""{
            self.formato = (atributos?.formato.replacingOccurrences(of: "m", with: "M"))!
            self.formato = self.formato.replacingOccurrences(of: "n/", with: "")
            self.formato = self.formato.replacingOccurrences(of: "j", with: "EEEE")
            self.formato = self.formato.replacingOccurrences(of: "/", with: "\(atributos!.separador)")
            self.formatter.dateFormat = "\(self.formato)"
            self.formatter.locale = Locale(identifier: "es_MX")
            self.datePicker.locale = Locale(identifier: "es_MX")
        }
        
        if atributos!.valor != "" && atributos!.valor != " "{
            textFieldDidChange(txtInput)
        }
        
        if (atributos?.ayuda != nil){
            self.btnInfo.isHidden = false }
        else{
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
    
    public func setObjectHora(obj: Elemento){
        
        elemento = obj
        atributosHora = obj.atributos as? Atributos_hora
        txtInput.text = atributosHora?.valor
        lblTitle.text = atributosHora?.titulo
        lblSubtitle.text = atributosHora?.subtitulo
        txtInput.placeholder = atributosHora?.mascara
        
        setMinMax()
        setExpresionRegular()
        setOcultarTitulo(atributosHora!.ocultartitulo)
        setOcultarSubtitulo(atributosHora!.ocultarsubtitulo)
        setRequerido(atributosHora!.requerido)
        setVisible(atributosHora!.visible)
        setHabilitado(atributosHora!.habilitado)
        
        if atributosHora?.hora != ""{
            self.formato = (atributosHora?.hora.replacingOccurrences(of: "i", with: "mm"))!
            self.formatter.dateFormat = "\(self.formato)"
            self.formatter.locale = Locale(identifier: "es_MX")
            self.datePicker.locale = Locale(identifier: "es_MX")
        }
        if atributosHora!.valor != "" && atributosHora!.valor != " "{
            textFieldDidChange(txtInput)
        }
        
        if (atributosHora?.ayuda != nil){
            self.btnInfo.isHidden = false }
        else{
            self.btnInfo.isHidden = true
            for constraint in self.contentView.constraints {
                if constraint.identifier == "lblLeftTitle" {
                    constraint.constant = -20
                    self.layoutIfNeeded()
                }
            }
        }
        guard let ayuda = atributosHora?.ayuda, !ayuda.isEmpty else {
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
        selectionStyle = row.isDisabled ? .none : .default
        datePicker.setDate(row.value ?? Date(), animated: row is CountDownPickerRow)
        datePicker.minimumDate = (row as? DatePickerRowProtocol)?.minimumDate
        datePicker.maximumDate = (row as? DatePickerRowProtocol)?.maximumDate
        if let minuteIntervalValue = (row as? DatePickerRowProtocol)?.minuteInterval {
            datePicker.minuteInterval = minuteIntervalValue
        }
        if row.value == nil{
            self.txtInput.text = ""
            self.updateIfIsValid()
        }else{
           self.updateIfIsValid()
        }
    }
    
    // MARK: - INIT
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        datePicker = UIDatePicker()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        datePicker = UIDatePicker()
        super.init(coder: aDecoder)
    }
    
    deinit {
        datePicker.removeTarget(self, action: nil, for: .allEvents)
    }
    
    open override func setup() {
        super.setup()
        
        let apiObject = ObjectFormManager<FechaCell>()
        apiObject.delegate = self
        accessoryType = .none
        editingAccessoryType =  .none
        height = {return 72}
        btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        
        if (fechaRow != nil){
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        if (horaRow != nil){
            datePicker.datePickerMode = .time
            datePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        }
        
        txtInput.isUserInteractionEnabled = false
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
        if self.fechaRow != nil{
            row.value = datePicker.date
            txtInput.text = formatter.string(from: datePicker.date)
            //setEditedFecha(v: txtInput.text!)
            //self.updateIfIsValid()
        }else if self.horaRow != nil{
            row.value = datePicker.date
            self.txtInput.text = self.formatter.string(from: self.datePicker.date)
            //setEditedHora(v: txtInput.text!)
            //self.updateIfIsValid()
        }
        //self.updateIfIsValid()
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
                est!.Campo = "Fecha"
                est!.NombrePagina = atributos!.elementopadre
                est!.OrdenCampo = atributos!.ordencampo
            }else if atributosHora != nil{
                est!.Campo = "Hora"
                est!.NombrePagina = atributosHora!.elementopadre
                est!.OrdenCampo = atributosHora!.ordencampo
            }
            est!.FechaEntrada = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Latitud = ConfigurationManager.shared.latitud
            est!.Longitud = ConfigurationManager.shared.longitud
            est!.Usuario = ConfigurationManager.shared.usuarioUIAppDelegate.User
            est!.Dispositivo = UIDevice().model
            est!.NombrePlantilla = ""
            est!.Sesion = ConfigurationManager.shared.guid
            est!.PlantillaID = 0
            let idPag = atributos!.elementopadre.replacingOccurrences(of: "formElec_element", with: "")
            est!.PaginaID = Int(idPag) ?? 0
            let idElem = elemento._idelemento.replacingOccurrences(of: "formElec_element", with: "")
            est!.CampoID = Int(idElem) ?? 0
        }
    }
    
    // MARK: TEXTFIELDDELEGATE
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.fechaRow != nil{
            self.fechaRow.didSelect()
            setEstadistica()
        }else if self.horaRow != nil{
            self.horaRow.didSelect()
            setEstadistica()
        }
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
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
        
    }
    
    // MARK: - PROTOCOLS FUNCTIONS
    open override func cellCanBecomeFirstResponder() -> Bool {
        return canBecomeFirstResponder
    }
    
    override open var canBecomeFirstResponder: Bool {
        return !row.isDisabled
    }
    
    // Aditional Func Objc
    @objc public func setAyuda(_ sender: Any) {
        
        var help = "No hay ayuda disponible"
        if self.fechaRow != nil{
            if isInfoToolTipVisible{
                toolTip!.dismiss()
                isInfoToolTipVisible = false
                return
            }else{
                if atributos?.ayuda != "" { help = (atributos?.ayuda)! }
                toolTip = EasyTipView(text: "\(help)", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.fechaRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }else if self.horaRow != nil{
            if isInfoToolTipVisible{
                toolTip!.dismiss()
                isInfoToolTipVisible = false
                return
            }else{
                if atributosHora?.ayuda != "" { help = (atributosHora?.ayuda)! }
                toolTip = EasyTipView(text: "\(help)", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.horaRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }
        
    }
    
    override open var inputView: UIView? {
        if let v = row.value {
            datePicker.setDate(v, animated:row is CountDownRow)
        }
        return datePicker
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        row.value = sender.date
        txtInput.text = formatter.string(from: datePicker.date)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.updateIfIsValid()
        }
        triggerEvent("alcambiar")
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        row.value = sender.date
        txtInput.text = formatter.string(from: datePicker.date)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.updateIfIsValid()
        }
        triggerEvent("alcambiar")
    }
    
}

// MARK: - OBJECTFORMDELEGATE
extension FechaCell: ObjectFormDelegate{
    
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
                if atributosHora != nil{
                    self.elemento.validacion.needsValidation = atributosHora.requerido
                }
                
                if row.isValid && txtInput.text != "" {
                    self.elemento.validacion.validado = true
                    if atributos != nil{
                        let formatMetaValue = DateFormatter()
                        formatMetaValue.dateFormat = "yyyyMMdd"
                        self.elemento.validacion.valor = txtInput.text!
                        self.elemento.validacion.valormetadato  = formatMetaValue.string(from: row.value!)
                    }
                    if atributosHora != nil{
                        let formatMetaValue = DateFormatter()
                        formatMetaValue.dateFormat = "H:mm"
                        self.elemento.validacion.valor = txtInput.text!
                        self.elemento.validacion.valormetadato  = formatMetaValue.string(from: row.value!)
                    }
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

    public func setMinMax(){}
    public func setExpresionRegular(){}
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
                }else{
                    self.bgHabilitado.isHidden = false;
                    self.row.baseCell.isUserInteractionEnabled = false
                }
                self.layoutIfNeeded()
            if self.fechaRow != nil{
                self.fechaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
                self.fechaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
            }else if self.horaRow != nil{
                self.horaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
                self.horaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
            }
            
        }
    }
    public func setEditedFecha(v: String){
        if v != ""{
            self.formatter.dateFormat = "dd/MM/yyyy"
            self.formatter.locale = Locale(identifier: "es_MX")
            let fechaProcesed = v.split{$0 == "/"}.map(String.init)
            if fechaProcesed.count == 3{
                let value = self.formatter.date(from: "\(fechaProcesed[0])/\(fechaProcesed[1])/\(fechaProcesed[2])")
                if value != nil{
                    txtInput.text = self.formatter.string(from: value!)
                    row.value = value
                }
            }else{
                if fechaProcesed[0].count == 8{
                    let start = v.index(v.startIndex, offsetBy: 4)
                    let end = v.index(v.endIndex, offsetBy: -2)
                    let range = start..<end
                    let mes = v[range]
                    let anio = v.prefix(4)
                    let dia = v.suffix(2)
                    let value = self.formatter.date(from: "\(anio)/\(mes)/\(dia)")
                    txtInput.text = self.formatter.string(from: value!)
                    row.value = value
                }else{
                    let value = self.formatter.date(from: "\(2018)/\(1)/\(1)")
                    if value != nil{
                        txtInput.text = self.formatter.string(from: value!)
                        row.value = value
                    }
                }
            }
            
            setEstadistica()
            // MARK: - Estadística
            est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Resultado = v
            est!.KeyStroke += 1
            elemento.estadisticas = est!
            
            textFieldDidChange(txtInput)
            triggerEvent("alentrar")
        }else{
            txtInput.text = ""
            row.value = nil
            
            setEstadistica()
            // MARK: - Estadística
            est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Resultado = ""
            est!.KeyStroke += 1
            elemento.estadisticas = est!
        }
    }
    
    public func setEditedHora(v: String){
        if v != ""{
            txtInput.text = v
            
            setEstadistica()
            // MARK: - Estadística
            est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Resultado = v
            est!.KeyStroke += 1
            elemento.estadisticas = est!
            
            textFieldDidChange(txtInput)
            triggerEvent("alentrar")
        }else{
            txtInput.text = ""
            row.value = nil
            
            setEstadistica()
            // MARK: - Estadística
            est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
            est!.Resultado = ""
            est!.KeyStroke += 1
            elemento.estadisticas = est!
            
            textFieldDidChange(txtInput)
            triggerEvent("alentrar")
        }
        
    }
    public func setEdited(v: String){}
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
                
                if self.atributosHora != nil{
                    if bool{
                        self.row.hidden = false
                        self.height = {return 72}
                        self.atributosHora?.visible = true
                    }else{
                        self.row.hidden = true
                        self.height = {return 0}
                        self.atributosHora?.visible = false
                    }
                }
                self.layoutIfNeeded()
            
            if self.fechaRow != nil{
                self.fechaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
                self.fechaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
            }else if self.horaRow != nil{
                self.horaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
                self.horaRow.cell.formCell()?.formViewController()?.tableView.reloadData()
            }
            
        }
    }
    public func setRequerido(_ bool: Bool){
        self.elemento.validacion.needsValidation = bool
        DispatchQueue.main.async {
                var rules = RuleSet<Date>()
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

        if atributosHora != nil, (atributosHora?.eventos.count)! > 0{
            for evento in (atributosHora?.eventos)!{
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


