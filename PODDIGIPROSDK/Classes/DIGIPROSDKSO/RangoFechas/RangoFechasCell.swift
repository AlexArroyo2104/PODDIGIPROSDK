//
//  RangoFechasCell.swift
//  FE
//
//  Created by Jonathan Viloria M on 12/3/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public class RangoFechasCell: Cell<String>, CellType, UITextFieldDelegate, CalendarDateRangePickerViewControllerDelegate {
    
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
    
    var navigationController: UINavigationController?
    
    public var formDelegate: FormularioDelegate?
    
    public var genericRow: RangoFechasRow! {return row as? RangoFechasRow}
    public var elemento = Elemento()
    public var atributos: Atributos_rangofechas!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var formato = ""
    public let formatter = DateFormatter()
    public var est: FEEstadistica? = nil

    @IBAction func RangoBtnAction(_ sender: Any) {
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = Date()
        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateRangePickerViewController.selectedStartDate = Date()
        dateRangePickerViewController.selectedEndDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        dateRangePickerViewController.title = "Selecciona un rango de fechas"
        navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        genericRow.baseCell.formViewController()?.navigationController?.present(navigationController!, animated: true, completion: nil)
    }
    
    public func didTapCancel() {
        print("Se ha cancelado el rango de fechas")
        row.value = nil
        txtInput.text = ""
        self.updateIfIsValid()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        let start = dateformatter.string(from: startDate)
        let end = dateformatter.string(from: endDate)
        self.row.value = "\(start) - \(end)"
        setEdited(v: "\(start) - \(end)")
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
        if isInfoToolTipVisible{
            toolTip!.dismiss()
            isInfoToolTipVisible = false
        }
    }
    
    public func setObject(obj: Elemento){
        elemento = obj
        atributos = obj.atributos as? Atributos_rangofechas
        
        if atributos!.valorinicial.isEmpty && atributos!.valorfinal.isEmpty{
            txtInput.text = ""
        }else{
           txtInput.text = "\(atributos!.valorinicial) - \(atributos!.valorfinal)"
        }
       
        txtInput.placeholder = atributos?.mascara
        lblTitle.text = atributos?.titulo
        lblSubtitle.text = atributos?.subtitulo
        
        setOcultarTitulo(atributos!.ocultartitulo)
        setOcultarSubtitulo(atributos!.ocultarsubtitulo)
        setRequerido(atributos!.requerido)
        setVisible(atributos!.visible)
        setHabilitado(atributos!.habilitado)
        
        if atributos!.formato != ""{
            self.formato = atributos!.formato.replacingOccurrences(of: "m", with: "M")
            self.formato = self.formato.replacingOccurrences(of: "n/", with: "")
            self.formato = self.formato.replacingOccurrences(of: "j", with: "EEEE")
            self.formato = self.formato.replacingOccurrences(of: "/", with: "\(atributos!.separador)")
            self.formatter.dateFormat = "\(self.formato)"
            self.formatter.locale = Locale(identifier: "es_MX")
            //self.datePicker.locale = Locale(identifier: "es_MX")
        }
        
        txtInput.keyboardType = .default
        
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
    
    // MARK: - ESTADISTICAS
    open func setEstadistica(){
        if est == nil{
            // MARK: - Estadística
            est = FEEstadistica()
            if atributos != nil{
                est!.Campo = "Rango Fecha"
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
    
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        
        let apiObject = ObjectFormManager<RangoFechasCell>()
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
    
    override open func update() {
        super.update()
    }
    
    // MARK: TextFieldDelegate
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.RangoBtnAction((Any).self)
        setEstadistica()
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
        textFieldDidChange(textField)
        textField.text = row.value
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
        guard let textValue = textField.text else {
            row.value = nil
            return
        }
        row.value = textValue
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
                else{
                    self.btnInfo.isHidden = true
                }
                toolTip = EasyTipView(text: "\(help)", preferences: EasyTipView.globalPreferences)
                toolTip!.show(forView: self.btnInfo, withinSuperview: self.genericRow.cell.formCell()?.formViewController()?.tableView)
                isInfoToolTipVisible = true
                return
            }
        }
    }

}

extension RangoFechasCell: ObjectFormDelegate{
    
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
            self.elemento.validacion.validado = false
            self.elemento.validacion.valor = ""
            self.elemento.validacion.valormetadato = ""
        }
    }
    
    public func setMinMax() {}
    
    public func setExpresionRegular() {}
    
    public func setOcultarTitulo(_ bool: Bool) {
        DispatchQueue.main.async {
                if bool{
                    self.lblTitle.isHidden = true
                }else{
                    self.lblTitle.isHidden = false
                }
                self.layoutIfNeeded()
        }
    }
    
    public func setOcultarSubtitulo(_ bool: Bool) {
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
        triggerEvent("alentrar")
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
