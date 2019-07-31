//
//  TablaCell.swift
//  FE
//
//  Created by Jonathan Viloria M on 12/7/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

open class TablaCell: Cell<String>, CellType, TablaPlantillaViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
   
    // MARK: - IBOUTLETS AND VARS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewValidation: UIView!
    @IBOutlet weak var bgHabilitado: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var agregarBtn: UIButton!
    @IBOutlet weak var btnMultiEdicion: UIButton!
    @IBOutlet weak var tableView: SpreadsheetView!
    
    public var records = [(record: Int, json: String)]()
    var counter = 0
    var y = 50
    var x = 10
    var w = 0
    var h = 40
    
    public var formDelegate: FormularioDelegate?
    
    var label: UILabel = UILabel()
    var viewHolder: UIView = UIView()
    var myCollectionView: UICollectionView?
    var rowsTable: Int = 0
    var senderTag: Int = 0
    
    var arrayElementos: Array<Elemento>?
    var dictValues = Dictionary<String, (docid:String, habilitado:String, valor:String, valormetadato:String, visible:String)>()
    public var elementsForValidate = [String: String]()
    public var ElementosArray:NSMutableDictionary = NSMutableDictionary()
    var viewController: TablaPlantillaViewController?
    var arrayRows = [String]()
    var emptyArray = [String]()
    var dataRows = [[String]]()
    var nameElement = [String]()
    
    var navigationController: UINavigationController?
    
    public var genericRow: TablaRow! {return row as? TablaRow}
    public var elemento = Elemento()
    public var atributos: Atributos_tabla!
    public var isInfoToolTipVisible = false
    public var toolTip: EasyTipView?
    public var isServiceMessageDisplayed = 0
    public var est: FEEstadistica? = nil

    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func didTapCancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public func didTapSave(_ formulario: Form){
        
        elementsForValidate = [String: String]()
        for elem in arrayElementos!{
            if FormularioUtilities.shared.checkIfElementIsVisible(elem){
                detectValidation(elem: elem, route: "\(elem._idelemento)")
            }
        }
        
        print("SAVE: \(elementsForValidate.count)")
        
        if elementsForValidate.count > 0{
            
            let alert = UIAlertController(title: "Alerta", message: "Aún tienes \(elementsForValidate.count) campos que necesitas llenar para validar tu formulario.", preferredStyle: UIAlertController.Style.alert)
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
            genericRow.baseCell.formViewController()?.present(alert, animated: true, completion: nil)
            
        }else{
            for elem in arrayElementos!{
                detectValue(elem: elem, isPrellenado: false)
            }
            let tablaArray = ElementosArray
            print("Tabla Array: \(tablaArray)")
            let prod: NSMutableDictionary = NSMutableDictionary()
            prod.setValue(counter, forKey: "id")
            prod.setValue(true, forKey: "checked")
            tablaArray.setValue(prod, forKey: "Acciones")
            var theJsonText = ""
            if let theJsonDataArray = try? JSONSerialization.data(withJSONObject: tablaArray, options: .sortedKeys){
                theJsonText = String(data: theJsonDataArray, encoding: String.Encoding.utf8)!
                theJsonText = theJsonText.replacingOccurrences(of: "\"{", with: "{")
                theJsonText = theJsonText.replacingOccurrences(of: "}}\",", with: "}},")
            }
            
            // Saving data to Json
            print("JSON SAVE: \(theJsonText)")
            records.append((record: counter, json: theJsonText))
            dataToTable(theJsonText)
            didTapGenerar()
            self.height = {return 360}
            tableView.reloadData()
            genericRow.updateCell()
            genericRow.baseCell.formViewController()?.tableView.reloadData()
            counter += 1
            myCollectionView!.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.update()
            }
            //row.reload()
        }
        
    }
    
    // MARK: - DATOS PARA LA TABLA
   
    func dataToTable(_ json: String){
        //print("JSON: \(json)")
        getValuesFromJson(json)
        self.arrayRows = [String]()
        self.emptyArray = [String]()
        for section in viewController!.form.allSections{
            for row in section.allRows{
                for dictValue in self.dictValues{
                    print("COUNT DICT: \( dictValue.value.valor.count)")
                    if dictValue.key == row.tag{
                       
                       
                            if row is TextoRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }else if row is NumeroRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }else if row is FechaRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }else if row is MonedaRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }else if row is TextoAreaRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }else if row is RangoFechasRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }else if row is HoraRow{
                                var array = [String]()
                                array.append(dictValue.value.valor)
                                self.arrayRows.append(dictValue.value.valor)
                            }
                        
                        if dictValue.value.valor == ""{
                            self.arrayRows.append("")
                        }
                        
                        print("ARRAY NEW: \(self.arrayRows)")
                    }else{
                        for emptyElement in self.nameElement{
                            if emptyElement.isEmpty{
                              self.emptyArray.append("")
                            }
                            
                            self.emptyArray.append("")
                        }
                    }
                }
                
            }
            
        }
        if arrayRows.isEmpty{
            self.dataRows.append(self.emptyArray)
        }else{
           self.dataRows.append(self.arrayRows)
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
    public func updateData(){
        print("Editing")
        self.arrayRows = [String]()
        self.emptyArray = [String]()
        print("VALUES ARRAY ROWS: \(self.arrayRows)")
        print("DATA ROWS: \(self.dataRows)")
        print("DATA ROWS NEW \(self.dataRows[self.senderTag])")
        getValuesFromJson(records[self.senderTag].json)
        
        print(viewController?.form.allSections as Any)
        for section in viewController!.form.allSections{
            for row in section.allRows{
                for dictValue in self.dictValues{
                    print("COUNT DICT: \( dictValue.value.valor.count)")
                    if dictValue.key == row.tag{
                        
                        
                        if row is TextoRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }else if row is NumeroRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }else if row is FechaRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }else if row is MonedaRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }else if row is TextoAreaRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }else if row is RangoFechasRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }else if row is HoraRow{
                            var array = [String]()
                            array.append(dictValue.value.valor)
                            self.arrayRows.append(dictValue.value.valor)
                        }
                        
                        if dictValue.value.valor == ""{
                            self.arrayRows.append("")
                        }
                        
                        print("ARRAY NEW: \(self.arrayRows)")
                    }else{
                        for emptyElement in self.nameElement{
                            if emptyElement.isEmpty{
                                self.emptyArray.append("")
                            }
                            
                            self.emptyArray.append("")
                        }
                    }
                }
                
            }
            
        }
        if arrayRows.isEmpty{
            self.dataRows.append(self.emptyArray)
        }else{
            self.dataRows[self.senderTag].removeAll()
            self.dataRows[self.senderTag].append(contentsOf: self.arrayRows)
        }
        
        self.tableView.reloadData()
        print("NEW ARRAY: \(self.dataRows[self.senderTag])")
    }
    
    
    
    
    func insertElementAtIndex(element: String?, index: Int) {
        
        while arrayRows.count <= index {
            arrayRows.append("")
        }
        
        arrayRows.insert(element!, at: index)
    }
    
    
    public func didTapGenerar() {
        var dictArray = Array<String>()
        
        for record in records{ dictArray.append(record.json) }
        print("RECORDS: \(records)")
        do{
            let options = JSONSerialization.WritingOptions(rawValue: 0)
            let data = try JSONSerialization.data(withJSONObject: dictArray, options: options)
            if var string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = string.replacingOccurrences(of: "\"{", with: "{") as NSString
                string = string.replacingOccurrences(of: "}}\"", with: "}}") as NSString
                string = string.replacingOccurrences(of: "\\\"", with: "\"") as NSString
                
                setEdited(v: string as String)
            }
        }catch { setEdited(v: "") }
    }
    
    public func getValuesFromJson(_ json: String){
        do{
            let customJson = json.replacingOccurrences(of: "\r\n", with: ",")
            let dict = try JSONSerializer.toDictionary(customJson)
            dictValues = Dictionary<String, (docid:String, habilitado:String, valor:String, valormetadato:String, visible:String)>()
            print("VALUES ICt")
            for dato in dict{
                
                let dictValor = dato.value as! NSMutableDictionary
                
                let docid = dictValor.value(forKey: "docid") as? String ?? "0"
                let habilitado = dictValor.value(forKey: "habilitado") as? String ?? "false"
                let valor = dictValor.value(forKey: "valor") as? String ?? ""
                let valormetadato = dictValor.value(forKey: "valormetadato") as? String ?? ""
                let visible = dictValor.value(forKey: "visible") as? String ?? "false"
                
                dictValues["\(dato.key)"] = (docid: docid, habilitado: habilitado, valor: valor, valormetadato: valormetadato, visible: visible)
                
                
            }
            print("DICT VALUES: \(self.dictValues)")
        }catch{
            print("No values asigned")
        }
    }
    
    public func setValuesFromJson(){
        // Saving data to Json
        if row.value == nil{return}
        do{
            let arrayDictionary = try JSONSerializer.toArray(row.value!)
            for keyArray in arrayDictionary{
                let dictArray = keyArray as! NSMutableDictionary
                
                for (index, dict) in dictArray.enumerated(){
                    if dict.key as! String != "Acciones"{
                        let dictValor = dict.value as! NSMutableDictionary
                        print(dictValor)
                        let docid = dictValor.value(forKey: "docid") as? String ?? "0"
                        let habilitado = dictValor.value(forKey: "habilitado") as? String ?? "false"
                        let valor = dictValor.value(forKey: "valor") as? String ?? ""
                        let valormetadato = dictValor.value(forKey: "valormetadato") as? String ?? ""
                        let visible = dictValor.value(forKey: "visible") as? String ?? "false"
                        dictValues["\(dict.key)"] = (docid: docid, habilitado: habilitado, valor: valor, valormetadato: valormetadato, visible: visible)
                        records.append((record: index, json: valor))
                    }
                    
                }
            }
            
        }catch{
            print(error)
        }
        genericRow.updateCell()
        genericRow.baseCell.formViewController()?.tableView.reloadData()
        counter += records.count
        myCollectionView!.reloadData()
        tableView.reloadData()
    }
    
    public func didTapSaveCancel(_ formulario: Form) {
        elementsForValidate = [String: String]()
        for elem in arrayElementos!{
            if FormularioUtilities.shared.checkIfElementIsVisible(elem){
                detectValidation(elem: elem, route: "\(elem._idelemento)")
            }
        }
        
        if elementsForValidate.count > 0{
            
            let alert = UIAlertController(title: "Alerta", message: "Aún tienes \(elementsForValidate.count) campos que necesitas llenar para validar tu formulario.", preferredStyle: UIAlertController.Style.alert)
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
            genericRow.baseCell.formViewController()?.present(alert, animated: true, completion: nil)
            
        }else{
            for elem in arrayElementos!{
                detectValue(elem: elem, isPrellenado: false)
            }
            let tablaArray = ElementosArray
            print("TABLA ARRAY 1: \(tablaArray)")
            let prod: NSMutableDictionary = NSMutableDictionary()
            prod.setValue(counter, forKey: "id")
            prod.setValue(true, forKey: "checked")
            tablaArray.setValue(prod, forKey: "Acciones")
            print("TABLA ARRAY 2: \(tablaArray)")
            var theJsonText = ""
            
            if let theJsonDataArray = try? JSONSerialization.data(withJSONObject: tablaArray, options: .sortedKeys){
                print("JSON DATA ARRAY: \(theJsonDataArray)")
                theJsonText = String(data: theJsonDataArray, encoding: String.Encoding.utf8)!
            }
            
            // Saving data to Json
            print("JSON VALUES: \(theJsonText)")
            records.append((record: counter, json: theJsonText))
            didTapGenerar()
            dataToTable(theJsonText)
            self.height = {return 360}
            tableView.reloadData()
            genericRow.updateCell()
            genericRow.baseCell.formViewController()?.tableView.reloadData()
            counter += 1
            navigationController?.dismiss(animated: true, completion: nil)
            myCollectionView!.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
               self.update()
            }
            
            
            //row.reload()
           // print("NAMES ARRAY: \(self.nameElement)")
            
        }
    }
    
    @objc func editBtnAction(_ sender: UIButton){
        print("Editing")
        print(sender.tag)
        self.senderTag = sender.tag
        print("VALUES ARRAY ROWS: \(self.arrayRows)")
        print("DATA ROWS: \(self.dataRows)")
        print("DATA ROWS NEW \(self.dataRows[sender.tag])")
        getValuesFromJson(records[sender.tag].json)
        
        for section in viewController!.form.allSections{
            
            for row in section.allRows{
                self.elementRow(e: row)
                
            }
            
        }
        
        viewController!.isEdited = true
        navigationController = UINavigationController(rootViewController: viewController!)
        genericRow.baseCell.formViewController()?.navigationController?.present(navigationController!, animated: true, completion: nil)
    }
    
    
    
    @objc func visualizeBtnAction(_ sender: UIButton){
        print("Visualizing")
        print(sender.tag)
        getValuesFromJson(records[sender.tag].json)
        
        for section in viewController!.form.allSections{
            
            for row in section.allRows{
                
                for dictValue in self.dictValues{
                    if dictValue.key == row.tag{
                        guard let baseRow = row as? TextoRow else{ continue }
                        baseRow.cell.setEdited(v: dictValue.value.valor)
                        baseRow.cell.bgHabilitado.isHidden = false
                        baseRow.baseCell.isUserInteractionEnabled = false
                        baseRow.disabled = true
                        baseRow.evaluateDisabled()
                        baseRow.cell.update()
                    }
                }
                
            }
            
        }
        
        viewController!.isEdited = false
        navigationController = UINavigationController(rootViewController: viewController!)
        genericRow.baseCell.formViewController()?.navigationController?.present(navigationController!, animated: true, completion: nil)
    }
    
    @objc func trashBtnAction(_ sender: UIButton){
        print("Trashing")
        print(sender.tag)
        records.remove(at: sender.tag)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print("Deleting: \(indexPath)")
        self.myCollectionView!.deleteItems(at: [indexPath])
        self.myCollectionView!.reloadItems(at: self.myCollectionView!.indexPathsForVisibleItems)
        genericRow.baseCell.formViewController()?.tableView.reloadData()
        self.dataRows.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @IBAction func AgregarBtnAction(_ sender: Any) {
        genericRow.baseCell.formViewController()?.navigationController?.present(navigationController!, animated: true, completion: nil)
    }
    
    // MARK: SETTING
    public func setObject(obj: Elemento, hijos: Form){
        self.tag = 00001
        w = Int(self.frame.size.width - 20)
        elemento = obj
        atributos = obj.atributos as? Atributos_tabla
        
        lblTitle.text = atributos?.titulo
        lblSubtitle.text = atributos?.subtitulo
        
        setOcultarTitulo(atributos!.ocultartitulo)
        setOcultarSubtitulo(atributos!.ocultarsubtitulo)
        setRequerido(atributos!.requerido)
        setVisible(atributos!.visible)
        setHabilitado(atributos!.habilitado)
        
        viewController = TablaPlantillaViewController.init(nibName: "TablaPlantillaViewController", bundle: Cnstnt.Path.so)
        
        viewController!.form = hijos
        
       
        viewController!.delegate = self
        navigationController = UINavigationController(rootViewController: viewController!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.frame.width - 80, height: 50)
        
        myCollectionView = UICollectionView(frame: CGRect(x: 10, y: 30, width: self.frame.width - 60, height: 65), collectionViewLayout: layout)
        myCollectionView!.dataSource = self
        myCollectionView!.delegate = self
        
       
        
        let nib = UINib(nibName: "TblCell", bundle: Cnstnt.Path.so)
        myCollectionView!.register(nib, forCellWithReuseIdentifier: "Cell")
        myCollectionView!.backgroundColor = UIColor.white
        self.addSubview(myCollectionView!)
        self.myCollectionView?.isHidden = true
        
        self.nameElement = [String]()
        for elem in hijos.allRows{
           self.elementType(e: elem)
        }
        
        if viewController?.form.allRows.count != nil{
            print("ROWS TABLE: \(self.nameElement.count)")
            self.rowsTable = self.nameElement.count
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
    
    open override func layoutSubviews() {
        tableView.reloadData()
    }
    
    
    public func setElements(_ elementos: Array<Elemento>){ arrayElementos = elementos }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! TblCell
        myCell.editBtn.addTarget(self, action: #selector(self.editBtnAction(_ :)), for: .touchUpInside)
        myCell.editBtn.tag = indexPath.row
        myCell.previewBtn.addTarget(self, action: #selector(self.visualizeBtnAction(_ :)), for: .touchUpInside)
        myCell.previewBtn.tag = indexPath.row
        myCell.trashBtn.addTarget(self, action: #selector(self.trashBtnAction(_ :)), for: .touchUpInside)
        myCell.trashBtn.tag = indexPath.row
        myCell.lblRow.text = "Fila: \(indexPath.row): "

        return myCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        
    }
    
    open override func setup() {
        super.setup()
        
        let apiObject = ObjectFormManager<TablaCell>()
        apiObject.delegate = self
        
        self.height = {return 110}
        
        self.btnInfo.addTarget(self, action: #selector(setAyuda(_:)), for: .touchDown)
        self.btnInfo.layer.borderWidth = 1.0
        self.btnInfo.layer.borderColor = UIColor.black.cgColor
        self.btnInfo.layer.cornerRadius = 2.0
        self.agregarBtn.layer.cornerRadius = 2.5
        self.btnMultiEdicion.layer.cornerRadius = 2.5
        self.lblMessage.layer.cornerRadius = 2.0
        self.lblError.layer.cornerRadius = 2.0
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .clear
        self.tableView.gridStyle = .solid(width: 1, color: .darkGray)
        self.tableView.register(FilaCell.self, forCellWithReuseIdentifier: String(describing: FilaCell.self))
        self.tableView.register(EditCell.self, forCellWithReuseIdentifier: String(describing: EditCell.self))
        self.tableView.register(DataCell.self, forCellWithReuseIdentifier: String(describing: DataCell.self))
        self.tableView.register(TitleCell.self, forCellWithReuseIdentifier: String(describing: TitleCell.self))
        self.tableView.register(RowCell.self, forCellWithReuseIdentifier: String(describing: RowCell.self))
        self.tableView.register(TrashCell.self, forCellWithReuseIdentifier: String(describing: TrashCell.self))
        
    }
    
    open override func update() {
        super.update()

        self.tableView.reloadData()
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
                est!.Campo = "Tabla"
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
    
    func elementType(e: BaseRow){
        let row = e
        switch row {
        case is TextoRow:
            let texto = row as? TextoRow
            self.nameElement.append((texto?.cell!.lblTitle.text!)!)
            break
        case is NumeroRow:
            let numero = row as? NumeroRow
            self.nameElement.append((numero?.cell!.lblTitle.text!)!)
            break
        case is TextoAreaRow:
            let textoArea = row as? TextoAreaRow
            self.nameElement.append((textoArea?.cell!.lblTitle.text!)!)
            break
        case is FechaRow:
            let fecha = row as? FechaRow
            self.nameElement.append((fecha?.cell!.lblTitle.text!)!)
            break
        case is MonedaRow:
            let moneda = row as? MonedaRow
            self.nameElement.append((moneda?.cell!.lblTitle.text!)!)
            break
        case is RangoFechasRow:
            let rangoFechas = row as? RangoFechasRow
            self.nameElement.append((rangoFechas?.cell!.lblTitle.text!)!)
            break
        case is HoraRow:
            let hora = row as? HoraRow
            self.nameElement.append((hora?.cell!.lblTitle.text!)!)
            break
        default:
            break
        }
        
    }
    
    func elementRow(e: BaseRow){
        let row = e
        switch row {
        case is TextoRow:
            let texto = row as? TextoRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    texto?.cell.setEdited(v: dictValue.value.valor)
                    texto?.cell.bgHabilitado.isHidden = true
                    texto?.baseCell.isUserInteractionEnabled = true
                    texto?.disabled = false
                    texto?.evaluateDisabled()
                    texto?.cell.update()
                }
            }
            break
        case is NumeroRow:
            let numero = row as? NumeroRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    numero?.cell.setEdited(v: dictValue.value.valor)
                    numero?.cell.bgHabilitado.isHidden = true
                    numero?.baseCell.isUserInteractionEnabled = true
                    numero?.disabled = false
                    numero?.evaluateDisabled()
                    numero?.cell.update()
                }
            }
            break
        case is TextoAreaRow:
            let textoArea = row as? TextoAreaRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    textoArea?.cell.setEdited(v: dictValue.value.valor)
                    textoArea?.cell.bgHabilitado.isHidden = true
                    textoArea?.baseCell.isUserInteractionEnabled = true
                    textoArea?.disabled = false
                    textoArea?.evaluateDisabled()
                    textoArea?.cell.update()
                }
            }
            break
        case is FechaRow:
            let fecha = row as? FechaRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    fecha?.cell.setEdited(v: dictValue.value.valor)
                    fecha?.cell.bgHabilitado.isHidden = true
                    fecha?.baseCell.isUserInteractionEnabled = true
                    fecha?.disabled = false
                    fecha?.evaluateDisabled()
                    fecha?.cell.update()
                }
            }
            break
        case is MonedaRow:
            let moneda = row as? MonedaRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    moneda?.cell.setEdited(v: dictValue.value.valor)
                    moneda?.cell.bgHabilitado.isHidden = true
                    moneda?.baseCell.isUserInteractionEnabled = true
                    moneda?.disabled = false
                    moneda?.evaluateDisabled()
                    moneda?.cell.update()
                }
            }
            break
        case is RangoFechasRow:
            let rangoFechas = row as? RangoFechasRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    rangoFechas?.cell.setEdited(v: dictValue.value.valor)
                    rangoFechas?.cell.bgHabilitado.isHidden = true
                    rangoFechas?.baseCell.isUserInteractionEnabled = true
                    rangoFechas?.disabled = false
                    rangoFechas?.evaluateDisabled()
                    rangoFechas?.cell.update()
                }
            }
            break
        case is HoraRow:
            let hora = row as? HoraRow
            for dictValue in self.dictValues{
                if dictValue.key == row.tag{
                    
                    print("VALOR: \(dictValue.value.valor)")
                    hora?.cell.setEdited(v: dictValue.value.valor)
                    hora?.cell.bgHabilitado.isHidden = true
                    hora?.baseCell.isUserInteractionEnabled = true
                    hora?.disabled = false
                    hora?.evaluateDisabled()
                    hora?.cell.update()
                }
            }
            break
            
        default:
            break
        }
    }
    
}

// MARK: - DETECTION VALUES
extension TablaCell{
    func detectValidation(elem: Elemento, route: String){
        if elem.elementos != nil {
            for e in (elem.elementos?.elemento)!{
                detectValidation(elem: e, route: "\(route)|\(e._idelemento)")
            }
        }else{
            if elem.validacion.visible{
                if elem.validacion.needsValidation && elem.validacion.validado == false {
                    self.elementsForValidate["\(elem._idelemento)"] = "\(route)"
                }
            }
        }
    }
    
    public func setDataAttributes(elemento e:String, valor l:String, metadato m:String, habilitado h:Bool, visible v:Bool){
        let data = JsonDataResponse()
        data.valor = l
        data.valormetadato = m
        data.habilitado = h
        data.visible = v
        
        let prod: NSMutableDictionary = NSMutableDictionary()
        prod.setValue(data.valor, forKey: "valor")
        prod.setValue(data.valormetadato, forKey: "valormetadato")
        prod.setValue(data.habilitado, forKey: "habilitado")
        prod.setValue(data.visible, forKey: "visible")
        
        self.ElementosArray.setValue(prod, forKey: "\(e)")
    }
    
    func detectValue(elem: Elemento, isPrellenado: Bool){
        if elem.elementos != nil {
            for e in (elem.elementos?.elemento)!{
                detectValue(elem: e, isPrellenado: isPrellenado)
            }
        }else{
            if !isPrellenado{
                if elem.validacion.validado && elem.validacion.valor != "" {
                    // Checking if is anexo or simple object
                    self.setMetaAttributes(elem, isPrellenado)
                }
            }else{
                self.setMetaAttributes(elem, isPrellenado)
            }
        }
    }
    
    func setTipoDoc(_ e: Elemento) -> Int{
        switch e._tipoelemento {
        case "plantilla":
            return 0
        case "pagina":
            return 0
        case "seccion":
            return 0
        case "texto":
            return 0
        case "numero":
            return 0
        case "textarea":
            return 0
        case "password":
            return 0
        case "moneda":
            return 0
        case "boton":
            return 0
        case "fecha":
            return 0
        case "hora":
            return 0
        case "leyenda":
            return 0
        case "logico":
            return 0
        case "deslizante":
            return 0
        case "logo":
            return 0
        case "firma":
            let atr = e.atributos as! Atributos_firma
            return atr.tipodoc
        case "imagen":
            let atr = e.atributos as! Atributos_imagen
            return atr.tipodoc
        case "audio":
            let atr = e.atributos as! Atributos_audio
            return atr.tipodoc
        case "video":
            let atr = e.atributos as! Atributos_video
            return atr.tipodoc
        case "mapa":
            let atr = e.atributos as! Atributos_mapa
            return atr.tipodoc
        case "lista":
            return 0
        case "wizard":
            return 0
        case "rangofechas":
            return 0
        case "calculadorafinanciera":
            return 0
        default:
            return 0
        }
    }
    
    public func setMetaAttributes(_ e: Elemento, _ isPrellenado: Bool){
        let data = JsonDataResponse()
        switch e._tipoelemento {
        case "plantilla":
            //let atr = Atributos_plantilla()
            break
        case "pagina":
            //let atr = Atributos_pagina()
            break
        case "seccion":
            //let atr = Atributos_seccion()
            break
        case "texto":
            let atr = e.atributos as! Atributos_texto
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "numero":
            let atr = e.atributos as! Atributos_numero
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "textarea":
            let atr = e.atributos as! Atributos_textarea
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "password":
            let atr = e.atributos as! Atributos_password
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "moneda":
            let atr = e.atributos as! Atributos_moneda
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "boton":
            //let atr = Atributos_boton()
            break
        case "fecha":
            let atr = e.atributos as! Atributos_fecha
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "rangofechas":
            let atr = e.atributos as! Atributos_rangofechas
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "hora":
            let atr = e.atributos as! Atributos_hora
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "leyenda":
            //let atr = Atributos_leyenda()
            break
        case "logico":
            let atr = e.atributos as! Atributos_logico
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "deslizante":
            let atr = e.atributos as! Atributos_Slider
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "calculadorafinanciera":
            let atr = e.atributos as! Atributos_calculadora
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "logo":
            //let atr = Atributos_logo()
            break
        case "firma":
            let atr = e.atributos as! Atributos_firma
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "imagen":
            let atr = e.atributos as! Atributos_imagen
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "audio":
            let atr = e.atributos as! Atributos_audio
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "video":
            let atr = e.atributos as! Atributos_video
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "mapa":
            let atr = e.atributos as! Atributos_mapa
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        case "lista":
            let atr = e.atributos as! Atributos_lista
            data.valor = e.validacion.valor
            data.valormetadato = e.validacion.valormetadato
            data.habilitado = atr.habilitado
            data.visible = atr.visible
            
            let prod: NSMutableDictionary = NSMutableDictionary()
            switch atr.tipoasociacion{
            case "idid":
                prod.setValue(data.valor, forKey: "valor")
                prod.setValue(data.valor, forKey: "valormetadato")
                break
            case "iddesc":
                prod.setValue(data.valormetadato, forKey: "valor")
                prod.setValue(data.valor, forKey: "valormetadato")
                break
            case "descid":
                prod.setValue(data.valor, forKey: "valor")
                prod.setValue(data.valormetadato, forKey: "valormetadato")
                break
            case "descdesc":
                prod.setValue(data.valormetadato, forKey: "valor")
                prod.setValue(data.valormetadato, forKey: "valormetadato")
                break
            default:
                break
            }
            prod.setValue(data.habilitado, forKey: "habilitado")
            prod.setValue(data.visible, forKey: "visible")
            
            self.ElementosArray.setValue(prod, forKey: "\(e._idelemento)")
            break
        case "comboboxtemporal":
            let atr = e.atributos as! Atributos_listatemporal
            data.valor = e.validacion.valor
            //data.valormetadato = e.validacion.valormetadato
            data.habilitado = atr.habilitado
            data.visible = atr.visible
            
            let prod: NSMutableDictionary = NSMutableDictionary()
            /*switch atr.tipoasociacion{
            case "idid":
                prod.setValue(data.valor, forKey: "valor")
                prod.setValue(data.valor, forKey: "valormetadato")
                break
            case "iddesc":
                prod.setValue(data.valormetadato, forKey: "valor")
                prod.setValue(data.valor, forKey: "valormetadato")
                break
            case "descid":
                prod.setValue(data.valor, forKey: "valor")
                prod.setValue(data.valormetadato, forKey: "valormetadato")
                break
            case "descdesc":
                prod.setValue(data.valormetadato, forKey: "valor")
                prod.setValue(data.valormetadato, forKey: "valormetadato")
                break
            default:
                break
            }*/
            prod.setValue(data.habilitado, forKey: "habilitado")
            prod.setValue(data.visible, forKey: "visible")
            
            self.ElementosArray.setValue(prod, forKey: "\(e._idelemento)")
            break
        case "wizard":
            //let atr = Atributos_wizard()
            break
        case "tabla":
            let atr = e.atributos as! Atributos_tabla
            setDataAttributes(elemento: e._idelemento, valor: e.validacion.valor, metadato: e.validacion.valormetadato, habilitado: atr.habilitado, visible: atr.visible)
            break
        default:
            break
        }
    }
    
    public class JsonDataResponse{
        public var valormetadato = ""
        public var valor = ""
        public var visible = false
        public var habilitado = false
    }
    
    
}

// MARK: - OBJECTFORMDELEGATE
extension TablaCell: ObjectFormDelegate{
    // Protocolos Genéricos
    public func setVariableHeight(Height h: CGFloat) {}
    public func setMessage(_ string: String, _ state: String){
        self.lblError.isHidden = true
        self.lblSubtitle.isHidden = true
        if isServiceMessageDisplayed == 0{
            isServiceMessageDisplayed += 1
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.lblMessage.text = string
                    switch state{
                    case "message":
                        self?.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    case "valid":
                        self?.lblMessage.textColor = UIColor(red: 59/255, green: 198/255, blue: 81/255, alpha: 1.0)
                        break
                    case "alert":
                        self?.lblMessage.textColor = UIColor(red: 249/255, green: 154/255, blue: 0/255, alpha: 1.0)
                        break
                    case "error":
                        self?.lblMessage.textColor = UIColor(red: 227/255, green: 90/255, blue: 102/255, alpha: 1.0)
                        break
                    default:
                        self?.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    }
                    self?.lblMessage.isHidden = false
                    self?.layoutIfNeeded()
                    
                })
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(isServiceMessageDisplayed * 3), execute: {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.lblMessage.text = string
                    switch state{
                    case "message":
                        self?.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    case "valid":
                        self?.lblMessage.textColor = UIColor(red: 59/255, green: 198/255, blue: 81/255, alpha: 1.0)
                        break
                    case "alert":
                        self?.lblMessage.textColor = UIColor(red: 249/255, green: 154/255, blue: 0/255, alpha: 1.0)
                        break
                    case "error":
                        self?.lblMessage.textColor = UIColor(red: 227/255, green: 90/255, blue: 102/255, alpha: 1.0)
                        break
                    default:
                        self?.lblMessage.textColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
                        break
                    }
                    self?.lblMessage.isHidden = false
                    self?.layoutIfNeeded()
                    self?.isServiceMessageDisplayed -= 1
                })
            })
        }
    }
    
    public func updateIfIsValid(animated: Bool = true){
        self.lblMessage.isHidden = true
        if row.isValid{
            // Setting row as valid
            if row.value == nil{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: { [weak self] in
                        self?.lblSubtitle.isHidden = false
                        self?.lblError.text = ""
                        self?.lblError.isHidden = true
                        self?.viewValidation.backgroundColor = UIColor.gray
                        self?.layoutIfNeeded()
                    })
                }
                self.elemento.validacion.validado = false
                self.elemento.validacion.valor = ""
                self.elemento.validacion.valormetadato = ""
            }else{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: { [weak self] in
                        self?.lblSubtitle.isHidden = false
                        self?.lblError.text = ""
                        self?.lblError.isHidden = true
                        self?.viewValidation.backgroundColor = UIColor.green
                        self?.layoutIfNeeded()
                    })
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
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.lblSubtitle.isHidden = true
                    self?.viewValidation.backgroundColor = UIColor.red
                    if (self?.row.validationErrors.count)! > 0{
                        self?.lblError.text = self?.row.validationErrors[0].msg
                    }
                    self?.lblError.isHidden = false
                    self?.layoutIfNeeded()
                })
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
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if bool{
                    self?.lblTitle.isHidden = true
                }else{
                    self?.lblTitle.isHidden = false
                }
                self?.layoutIfNeeded()
            })
        }
    }
    public func setOcultarSubtitulo(_ bool: Bool){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if bool{
                    self?.lblSubtitle.isHidden = true
                }else{
                    self?.lblSubtitle.isHidden = false
                }
                self?.layoutIfNeeded()
            })
        }
    }
    public func setHabilitado(_ bool: Bool){
        self.elemento.validacion.habilitado = bool
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if bool{
                    self?.bgHabilitado.isHidden = true;
                    self?.row.baseCell.isUserInteractionEnabled = true
                    self?.row.disabled = false
                    self?.row.evaluateDisabled()
                }else{
                    self?.bgHabilitado.isHidden = false;
                    self?.row.baseCell.isUserInteractionEnabled = false
                    self?.row.disabled = true
                    self?.row.evaluateDisabled()
                }
                self?.layoutIfNeeded()
            })
            self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
        }
    }
    public func setEdited(v: String){
        row.value = v
        
        setEstadistica()
        // MARK: - Estadística
        est!.FechaSalida = ConfigurationManager.shared.utilities.getFormatDate()
        est!.Resultado = v
        est!.KeyStroke += 1
        elemento.estadisticas = est!
        
    }
    public func setVisible(_ bool: Bool){
        self.elemento.validacion.visible = bool
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                
                if self?.atributos != nil{
                    if bool{
                        self?.row.hidden = false
                        self?.height = {return 110}
                        self?.atributos?.visible = true
                    }else{
                        self?.row.hidden = true
                        self?.height = {return 0}
                        self?.atributos?.visible = false
                    }
                }
                
                self?.layoutIfNeeded()
            })
            self.genericRow.cell.formCell()?.formViewController()?.tableView.reloadData()
        }
    }
    public func setRequerido(_ bool: Bool){
        
        self.elemento.validacion.needsValidation = bool
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                var rules = RuleSet<String>()
                if bool{
                    rules.add(rule: ReglaRequerido())
                    self?.lblRequired.isHidden = false
                }else{
                    self?.lblRequired.isHidden = true
                }
                self?.layoutIfNeeded()
                self?.row.add(ruleSet: rules)
            })
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

////// CREACIÓN DE TABLA PARA AGREGAR LOS DATOS

extension TablaCell: SpreadsheetViewDelegate, SpreadsheetViewDataSource{
    
    // MARK: - DATASOURCE SPREADSHEETVIEW
    
    public func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        if records.count == 0{
            return 0
        }else{
            return 30
        }
        
    }
    
    public func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        if records.count == 0{
            return 0
        }else{
            if case 0 = column {
                return 50
            }else if case 1 = column{
                return 50
            } else if case 2 = column{
                return 50
            }else {
                return 90
            }
        }
    }
    
    public func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if records.count == 0{
            return 0
        }else{
            return 1 + 1 + 1 + self.rowsTable
        }
        
    }
    
    public func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        if records.count == 0{
            return 0
        }else{
           return 1 + records.count
        }
        
    }
    
    
    public func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if records.count == 0{
            return 0
        }else{
          return 3
        }
        
    }
    
    public func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        if records.count == 0{
            return 0
        }else{
            return 1
        }
    }
    
    
    public func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> CellSpread? {
        if records.count == 0{
            return nil
        }else{
            if case (2, 1...(records.count + 1)) = (indexPath.column, indexPath.row) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: FilaCell.self), for: indexPath) as! FilaCell
                
                
                cell.label.text = "\(indexPath.row - 1)"
                //cell.button.setTitle("Hola", for: .normal)
                return cell
            }else if case (0,1...(records.count + 1)) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: EditCell.self), for: indexPath) as! EditCell
                cell.button.setTitle("✏️", for: .normal)
                //cell.button.setImage(UIImage(named: "edit_button"), for: .normal)
                if indexPath.row == 0{
                    
                }else{
                    cell.button.addTarget(self, action: #selector(self.editBtnAction(_ :)), for: .touchUpInside)
                    cell.button.tag = indexPath.row - 1
                    
                }
                
                
                return cell
            }else if case (3...(self.nameElement.count + 3) ,1...(records.count + 1)) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DataCell.self), for: indexPath) as! DataCell
                
                let text = dataRows[indexPath.row - 1][indexPath.column - 3]
                if !text.isEmpty {
                    cell.label.text = text
                   
                } else {
                    cell.label.text = nil
                   
                }
                
                cell.label.text = dataRows[indexPath.row - 1][indexPath.column - 3]
                
                return cell
            }else if case (3...(self.nameElement.count + 2), 0) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TitleCell.self), for: indexPath) as! TitleCell
                cell.label.text = self.nameElement[indexPath.column - 3]
                cell.label.textColor = UIColor(hexFromString: atributos!.colorheadertexto)
                cell.label.backgroundColor = UIColor(hexFromString: atributos!.colorheader)
                
                return cell
            }else if case (2,0) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: RowCell.self), for: indexPath) as! RowCell
                
                cell.label.text = "No."
                cell.label.textColor = UIColor(hexFromString: atributos!.colorheadertexto)
                cell.label.backgroundColor = UIColor(hexFromString: atributos!.colorheader)
                return cell
            }else if case (1,1...(records.count + 1)) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TrashCell.self), for: indexPath) as! TrashCell
                cell.button.setTitle("🗑", for: .normal)
                //cell.button.setImage(UIImage(named: "edit_button"), for: .normal)
                if indexPath.row == 0{
                    
                }else{
                    cell.button.addTarget(self, action: #selector(self.trashBtnAction(_ :)), for: .touchUpInside)
                    cell.button.tag = indexPath.row - 1
                    
                }
                
                
                return cell
            }else if case (0,0) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: RowCell.self), for: indexPath) as! RowCell
                
                cell.label.text = ""
                cell.label.textColor = UIColor(hexFromString: atributos!.colorheadertexto)
                cell.label.backgroundColor = UIColor(hexFromString: atributos!.colorheader)
                return cell
            }else if case (1,0) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: RowCell.self), for: indexPath) as! RowCell
                
                cell.label.text = ""
                cell.label.textColor = UIColor(hexFromString: atributos!.colorheadertexto)
                cell.label.backgroundColor = UIColor(hexFromString: atributos!.colorheader)
                return cell
            }
            
        }
       
        
        return nil
    }
    
    
    // MARK: - DELEGATE SPREADSHEETVIEW
    public func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
        print("INDEX: \(indexPath.row)")
        
    }
    
    
}
