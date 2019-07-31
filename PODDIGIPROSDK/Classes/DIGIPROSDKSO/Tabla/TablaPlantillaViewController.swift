//
//  TablaPlantillaViewController.swift
//  FE
//
//  Created by Jonathan Viloria M on 12/7/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public protocol TablaPlantillaViewControllerDelegate {
    func didTapCancel()
    func didTapSave(_ formulario: Form)
    func didTapSaveCancel(_ formulario: Form)
    func didTapGenerar()
    func updateData()
    
}

public class TablaPlantillaViewController: FormViewController{
    
    @IBOutlet weak var btnCerrar: UIButton!
    @IBOutlet weak var btnAgregar: UIButton!
    @IBOutlet weak var btnLimpiar: UIButton!
    @IBOutlet weak var btnAgregarYcerrar: UIButton!
    
    

    var hijos: Form?
    var records = [(record: Int, child: Form)]()
    var titleSection = ""
    var isEdited = false
    var isVisualized = false
    let hud = JGProgressHUD(style: .dark)
    var arrayClean = [String]()
    
    public var delegate: TablaPlantillaViewControllerDelegate!
    
    @IBAction func closeBtnAction(_ sender: Any?) {
        delegate.didTapCancel()
    }
    
    @IBAction func limpiarAction(_ sender: Any) {
        for section in self.form.allSections{
            for base in section.allRows{
                self.elementRow(e: base)
            }
        }
    }
    
    @IBAction func agregarAction(_ sender: Any?) {
        delegate.didTapSave(self.form)
        self.limpiarAction((Any).self)
    }
    
    @IBAction func agregarCerrarAction(_ sender: Any?) {
        delegate.didTapSaveCancel(self.form)
    }
    
    @IBAction func generarAction(_ sender: Any?) {
        delegate.didTapGenerar()
    }
    
    @IBAction func updateDataAction(_ sender: Any?){
        delegate.updateData()
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view, typically from a nib.
        // Optional Values
        hud.textLabel.text = "Generando template"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        self.btnCerrar.layer.cornerRadius = 3.0
        self.btnAgregar.layer.cornerRadius = 3.0
        self.btnLimpiar.layer.cornerRadius = 3.0
        self.btnAgregarYcerrar.layer.cornerRadius = 3.0
        UIView.animate(withDuration: 0.1, animations: {
            self.hud.textLabel.text = "Éxito"
            self.hud.detailTextLabel.text = nil
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        })
        hud.dismiss(afterDelay: 0.25)
        settingMenu()
        self.tableView.reloadData()
    }
    
    func settingMenu(){
        // Do any additional setup after loading the view, typically from a nib.
        let menu = MenuView(title: "Menú", theme: LightMenuTheme()) { [weak self] () -> [MenuItem] in
            
            var menuHolder = [MenuItem]()
            
            menuHolder.append(ShortcutMenuItem(name: "Agregar y Cerrar", shortcut: (.command, "p"), action: {
                [weak self] in
                self!.agregarCerrarAction((Any).self)
            }))
            menuHolder.append(ShortcutMenuItem(name: "Limpiar", shortcut: (.command, "e"), action: {
                [weak self] in
                self!.limpiarAction((Any).self)
            }))
            menuHolder.append(ShortcutMenuItem(name: "Agregar", shortcut: (.command, "L"), action: {
                [weak self] in
                self!.agregarAction((Any).self)
            }))
            /*menuHolder.append(ShortcutMenuItem(name: "Generar Json", shortcut: (.command, "L"), action: {
                [weak self] in
                self!.generarAction((Any).self)
            }))*/
            return menuHolder
        }
        menu.contentAlignment = .right
        menu.tintColor = .black
        menu.frame = CGRect(x: 10, y: 25, width: 80, height: 40)
        menu.contentMode = .center
        view.addSubview(menu)
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func elementRow(e: BaseRow){
        let row = e
        switch row {
        case is TextoRow:
            let texto = row as? TextoRow
            if texto != nil{
                texto?.value = ""
                texto?.cell.txtInput.text = ""
                texto?.cell.updateIfIsValid()
                texto?.cell.update()
            }
            break
        case is NumeroRow:
            let numero = row as? NumeroRow
            if numero != nil{
                numero?.value = ""
                numero?.cell.txtInput.text = ""
                numero?.cell.updateIfIsValid()
                numero?.cell.update()
            }
            break
        case is TextoAreaRow:
            let textoArea = row as? TextoAreaRow
            if textoArea != nil{
                textoArea?.value = ""
                textoArea?.cell.txtInput.text = ""
                textoArea?.cell.updateIfIsValid()
                textoArea?.cell.update()
            }
            break
        case is FechaRow:
            let fecha = row as? FechaRow
            if fecha != nil{
                fecha?.value = Date()
                fecha?.cell.txtInput.text = ""
                fecha?.cell.updateIfIsValid()
                fecha?.cell.update()
            }
            break
        case is MonedaRow:
            let moneda = row as? MonedaRow
            if moneda != nil{
                moneda?.value = ""
                moneda?.cell.txtInput.text = ""
                moneda?.cell.updateIfIsValid()
                moneda?.cell.update()
            }
            break
        case is RangoFechasRow:
            let rangoFechas = row as? RangoFechasRow
            if rangoFechas != nil{
                rangoFechas?.value = ""
                rangoFechas?.cell.txtInput.text = ""
                rangoFechas?.cell.updateIfIsValid()
                rangoFechas?.cell.update()
            }
            break
        case is HoraRow:
            let hora = row as? HoraRow
            if hora != nil{
                hora?.value = Date()
                hora?.cell.txtInput.text = ""
                hora?.cell.updateIfIsValid()
                hora?.cell.update()
            }
            break
            
        default:
            break
        }
    }
}
